1) Linux: Disk 100% Full, App Down

1. Scenario (Production)
At 2 AM, payments API started returning 500. Alert: /var is 100% full. Logging service also stopped.

2. Interview question
“How will you troubleshoot a disk-full incident and restore service safely?”

3. What interviewer evaluates
Prioritization, safe cleanup, log handling, prevention.

4. Troubleshooting approach

Confirm which mount is full (df -h)

Identify top directories (du)

Find large files/logs/core dumps (find)

Free space safely (truncate logs, rotate logs, remove old artifacts)

Restart impacted services and confirm health

5. Commands / tools

df -h
df -i
du -sh /var/* | sort -h
find /var -type f -size +500M -ls
lsof +L1
truncate -s 0 /var/log/<biglog>
journalctl --vacuum-time=7d
systemctl restart <service>


6. Root cause possibilities
Log flood, debug mode enabled, core dumps, stuck retry loops, no log rotation, inode exhaustion.

7. Prevention / best practices
Logrotate, retention policy, alert on 70/80/90%, separate partition for logs, cap app logs, central logging.

8. Sample spoken answer
“First I’ll run df -h to see which mount is full and confirm inode with df -i. Then I’ll locate the largest directories using du and identify big files using find. If it’s logs, I’ll truncate or rotate them safely, and check deleted-but-open files via lsof +L1. Once space is recovered, I’ll restart affected services and verify API health. Finally I’ll add proper log rotation and alerts so this doesn’t repeat.”

2) Linux: High Load but CPU Not High

1. Scenario
Load average jumped to 30, but CPU usage is ~20%. App response time is high.

2. Question
“Why load can be high with low CPU, and how will you debug?”

3. Evaluates
Understanding of load vs CPU, IO wait, blocked processes.

4. Steps

Check load/CPU (uptime, top)

Check IO wait (iostat, vmstat)

Identify processes in D state (uninterruptible sleep)

Check disk saturation, NFS issues, DB storage latency

5. Commands

uptime
top
vmstat 1
iostat -x 1
ps -eo pid,stat,cmd | grep ' D '
dmesg | tail


6. Root causes
Disk IO bottleneck, NFS hang, slow EBS, RAID rebuild, heavy swap.

7. Prevention
IO monitoring, right EBS type/IOPS, caching, queue depth tuning, SLO alerts.

8. Spoken answer
“High load with low CPU usually means many processes are waiting—often on disk or network storage. I’ll check vmstat and iostat -x for IO wait and disk utilization. Then I’ll look for D-state processes. If storage latency is the issue, I’ll reduce IO pressure, verify EBS metrics, and scale IOPS or move to faster volumes. After mitigation, I’ll add dashboards for IO wait and disk latency.”

3) Linux: Server Reachable, Port Closed Suddenly

1. Scenario
EC2 is pingable, SSH works, but port 443 is closed. Users see connection refused.

2. Question
“How do you troubleshoot service down vs network issue?”

3. Evaluates
Service checks, port checks, logs, firewall.

4. Steps

Verify service status

Verify process listening on port

Check local firewall

Check app logs

5. Commands

systemctl status nginx
ss -tulnp | grep 443
curl -vk https://localhost
journalctl -u nginx -n 100
iptables -L -n


6. Root causes
Service crash, config error, cert expiry, port conflict, deploy broke service.

7. Prevention
Health checks, canary deploy, config tests, auto-restart, cert monitoring.

8. Spoken answer
“I’ll start by checking if the service is running and listening on 443 using systemctl and ss. Then I’ll curl locally to separate app vs network. If service is down, I’ll read logs and fix config/cert issues, then restart. After recovery, I’ll add deployment validation and alerts on port health and certificate expiry.”

4) Linux: “No Space Left” but df -h Shows Free Space

1. Scenario
App fails with “No space left on device”, but disk shows 40% free.

2. Question
“What can cause this and how do you confirm?”

3. Evaluates
Inodes and deleted-open files.

4. Steps

Check inode usage

Check deleted but open files

Check reserved blocks (ext)

5. Commands

df -i
lsof +L1
tune2fs -l /dev/xvda1 | grep -i reserved


6. Root causes
Inode exhaustion (many small files), open deleted logs, reserved blocks.

7. Prevention
Limit temp files, rotate logs, clean temp directories, monitor inodes.

8. Spoken answer
“If df -h shows space but app says no space, I’ll check df -i for inode exhaustion. Next I’ll run lsof +L1 to find large files deleted but still held open. Fix is removing excessive small files or restarting the process holding deleted logs. I’ll also add inode alerts and cleanup policies.”

5) AWS: EC2 Auto Scaling Not Launching Instances

1. Scenario
Traffic spike. ASG desired capacity increases, but instances are not coming up.

2. Question
“How do you troubleshoot ASG launch failures?”

3. Evaluates
ASG events, IAM, quotas, subnets, AMI.

4. Steps

Check ASG Activity history/events

Check Launch Template (AMI, SG, key, user-data)

Check subnet capacity + IPs

Check EC2 quota / vCPU limits

Check IAM instance profile permissions

5. Tools
ASG Activity, EC2 console, CloudTrail, Service Quotas, CloudWatch.

6. Root causes
No IPs in subnet, instance type unavailable, quota hit, bad AMI, user-data failing.

7. Prevention
Multi-AZ/subnet, mixed instance policy, quota alerts, golden AMI pipeline, launch test.

8. Spoken answer
“I’ll open the ASG activity history to see the exact failure reason. Then I’ll validate launch template settings, subnet IP availability, and service quotas. If instance type capacity is an issue, I’ll enable mixed instances and multiple AZs. If user-data/AMI is broken, I’ll test the AMI and fix bootstrap. Finally, I’ll add quota and subnet-IP monitoring.”

6) AWS: Sudden Cost Spike Overnight

1. Scenario
Finance reports AWS bill jumped 2x in one day.

2. Question
“How do you find the cost driver quickly and stop bleeding?”

3. Evaluates
Cost tools + triage.

4. Steps

Check Cost Explorer daily + service breakdown

Look for new resources: NAT GW, data transfer, EBS, CloudWatch logs, EKS

Use CloudTrail for who created resources

Apply immediate controls: stop/limit, budgets, SCP (if org)

5. Tools
Cost Explorer, CUR, Budgets, CloudTrail, AWS Config.

6. Root causes
NAT gateway data processing, runaway logs, misconfigured autoscaling, snapshot growth, data egress.

7. Prevention
Budgets + alerts, tagging, guardrails, log retention, architecture review.

8. Spoken answer
“I’ll start with Cost Explorer to identify which service increased and on which day. Then I’ll drill into usage type—often NAT data processing or logs. I’ll use CloudTrail to see what changed and who created it. I’ll stop or limit the offending resource immediately, then put budgets and alerts and enforce tagging so we catch it early next time.”

7) AWS: ALB Healthy but Users Still Fail

1. Scenario
ALB shows targets healthy, but customers still get 502 or timeouts intermittently.

2. Question
“How do you debug intermittent ALB errors?”

3. Evaluates
Understanding of target health vs app readiness, timeouts, logs.

4. Steps

Enable/inspect ALB access logs

Check target group health check path

Verify app response time and backend timeouts

Check security groups/NACL

Verify idle timeout, keep-alive, upstream timeouts

5. Tools
ALB access logs (S3), CloudWatch metrics, target group settings.

6. Root causes
Health check too shallow, app thread pool exhausted, wrong timeout values, connection resets.

7. Prevention
Better health checks (dependency checks), autoscaling, timeout tuning, dashboards.

8. Spoken answer
“Healthy targets only means health check passes. I’ll enable ALB access logs and correlate 502s with target response times and status codes. Then I’ll confirm health check path is meaningful and check backend timeouts and ALB idle timeout. If it’s capacity, I’ll scale targets and tune app pools. Finally I’ll improve health checks and add SLO alerts.”

8) AWS: RDS CPU High and App Slow

1. Scenario
RDS CPU is 90% and API latency increased.

2. Question
“How will you troubleshoot RDS performance?”

3. Evaluates
Metrics, slow queries, connections.

4. Steps

Check CloudWatch: CPU, FreeableMemory, Read/Write IOPS, Connections

Enable Performance Insights

Find top SQL and wait events

Check connection pool, long-running queries

Add indexes / optimize queries; scale if needed

5. Tools
CloudWatch, Performance Insights, Enhanced Monitoring.

6. Root causes
Missing indexes, bad query plan, sudden traffic, connection leak, autovacuum issues (Postgres), locks.

7. Prevention
Query reviews, indexes, PI alarms, pool settings, read replicas, caching.

8. Spoken answer
“I’ll first check RDS metrics to understand if the bottleneck is CPU, memory, or IO. Then I’ll use Performance Insights to identify top SQL and wait events. If queries are slow, I’ll optimize indexes and fix expensive queries. If connections are too many, I’ll fix pooling. For immediate relief, I might scale instance or add read replicas, and later improve query performance and add alerts.”

9) CI/CD: Deployment Succeeded but App Broken

1. Scenario
Pipeline is green. After deploy, login fails for all users.

2. Question
“How do you handle ‘successful deploy’ but failed production functionality?”

3. Evaluates
Rollback strategy, validation, canary.

4. Steps

Confirm incident and scope

Check release notes + diff

Check app logs, config/secrets changes

Rollback quickly to last known good version

Add smoke tests and post-deploy checks

5. Tools
Git, CI logs, Kubernetes rollout history, feature flags.

6. Root causes
Env var missing, DB migration issue, wrong config, backward incompatibility.

7. Prevention
Smoke tests, canary/blue-green, feature flags, migration strategy.

8. Spoken answer
“If prod is broken, first I’ll restore service fast—usually rollback to last stable release. Then I’ll investigate logs and config changes to identify what caused login failure. Many times it’s missing secrets or incompatible migrations. After fixing, I’ll add smoke tests and post-deploy validations and prefer canary releases to reduce blast radius.”

10) Docker: Container Keeps Restarting in Production

1. Scenario
A container in ECS/K8s shows CrashLoopBackOff / restarting every few seconds.

2. Question
“How do you debug a restarting container?”

3. Evaluates
Logs, exit code, probes, resources.

4. Steps

Check container logs

Check exit code / reason

Validate env vars and secrets

Check liveness/readiness probes

Check CPU/memory limits and OOM kills

5. Commands/tools
K8s:

kubectl describe pod <pod>
kubectl logs <pod> --previous
kubectl get events --sort-by=.metadata.creationTimestamp


Docker:

docker logs <id>
docker inspect <id>


6. Root causes
Bad config, missing secret, app crash, OOMKilled, failing probes.

7. Prevention
Proper probes, resource sizing, config validation, start-up delay, better error handling.

8. Spoken answer
“I’ll start with kubectl describe and kubectl logs --previous to see why it exited. Then I’ll verify config/secrets and check if it’s OOMKilled or probe failures. If probes are too aggressive, I’ll adjust initial delay and thresholds. If it’s real crash, I’ll fix the app or config and redeploy.”

11) Kubernetes: Pods Running but Service Not Reachable

1. Scenario
Pods are Running, but service returns no response.

2. Question
“How do you troubleshoot Kubernetes service connectivity?”

3. Evaluates
Selectors, endpoints, ports, network policies.

4. Steps

Validate service selector matches pod labels

Check endpoints are created

Confirm container port vs service targetPort

Test inside cluster (curl)

Check NetworkPolicy / security group rules (EKS)

5. Commands

kubectl get svc
kubectl describe svc <svc>
kubectl get endpoints <svc>
kubectl get pods --show-labels
kubectl exec -it <pod> -- curl -v http://<svc>:<port>


6. Root causes
Wrong selector, wrong port mapping, readiness failing, NetworkPolicy blocking.

7. Prevention
Helm validations, integration tests, standard labels, policy review.

8. Spoken answer
“I’ll check if the service selector matches pod labels and confirm endpoints exist. If endpoints are empty, selector or readiness is wrong. Then I’ll confirm service port and targetPort match the container port. I’ll test connectivity from a pod. If still failing, I’ll review NetworkPolicies and EKS security groups.”

12) Kubernetes: Nodes Not Ready Suddenly

1. Scenario
Multiple nodes became NotReady, pods evicted, traffic dropped.

2. Question
“What do you check when nodes go NotReady?”

3. Evaluates
Node health, kubelet, disk pressure, networking.

4. Steps

Check node conditions

Inspect kubelet logs (if access)

Check disk pressure/inodes

Check CNI issues

Check AWS node status (EKS/EC2)

5. Commands/tools

kubectl describe node <node>
kubectl get nodes
kubectl get events -A | tail


AWS: EC2 status checks, CloudWatch.

6. Root causes
Disk full, kubelet crash, CNI failure, instance network issue, too many pods.

7. Prevention
Node monitoring, disk cleanup, proper limits, managed node groups, PDBs.

8. Spoken answer
“I’ll run kubectl describe node to see if it’s DiskPressure, MemoryPressure, or network. Then I’ll check recent cluster events and correlate with EC2 status checks. If it’s disk pressure, I’ll clean disk/logs and ensure eviction thresholds are correct. If it’s CNI, I’ll verify the plugin health. Then I’ll improve node monitoring and capacity planning.”

13) Monitoring: Alerts Fire but No Real Issue (Noise)

1. Scenario
Pager alerts every hour, but services are fine. Team is getting alert fatigue.

2. Question
“How do you reduce noise without missing real incidents?”

3. Evaluates
SLO thinking, alert tuning.

4. Steps

Identify top noisy alerts

Validate if they map to user impact

Increase thresholds / add duration

Add correlation (multiple signals)

Use warning vs critical levels

5. Tools
CloudWatch alarms, Prometheus alert rules, Grafana dashboards.

6. Root causes
Too sensitive thresholds, missing “for” time, single-metric alerts.

7. Prevention
SLO-based alerts, runbooks, periodic tuning.

8. Spoken answer
“I’ll review the noisiest alerts and check if they reflect customer impact. Then I’ll tune them using time windows and correct thresholds, and require confirmation from multiple signals—like latency plus error rate. I’ll keep warnings for investigation and reserve critical alerts for real outages. This reduces fatigue and improves response quality.”

14) Security: IAM Key Leaked on GitHub

1. Scenario
A developer accidentally pushed AWS access key to a public repo.

2. Question
“What are your immediate steps and long-term actions?”

3. Evaluates
Incident response, IAM best practices.

4. Steps

Disable/rotate the key immediately

Check CloudTrail for suspicious activity

Identify resources created/changed

Add SCP/permissions boundaries if possible

Implement secret scanning and least privilege

5. Tools
IAM, CloudTrail, AWS Config, GitHub secret scanning.

6. Root causes
Hardcoded secrets, no scanning, poor processes.

7. Prevention
Use IAM roles, AWS SSO, secret manager, pre-commit hooks, CI scanning.

8. Spoken answer
“First I’ll deactivate the leaked key and rotate credentials. Then I’ll review CloudTrail to see if it was used and what actions happened. I’ll revert any unauthorized changes. After containment, I’ll enforce least privilege, move secrets to a secret manager, and enable secret scanning in repos and CI to prevent recurrence.”

15) AWS Networking: Private Subnet Instances Can’t Reach Internet

1. Scenario
EC2 in private subnet cannot download packages. Public subnet works.

2. Question
“What components do you check?”

3. Evaluates
NAT gateway, route tables, NACL/SG, DNS.

4. Steps

Verify route table has 0.0.0.0/0 to NAT

NAT gateway in public subnet with EIP

NACL rules allow outbound

Security group egress

DNS resolution

5. Tools/commands
AWS VPC console, reachability analyzer. On instance:

curl -I https://example.com
nslookup google.com
ip route


6. Root causes
No NAT route, NAT deleted, NACL blocking, DNS misconfig.

7. Prevention
Infra as code, monitoring NAT, multi-AZ NAT, route checks.

8. Spoken answer
“For private subnet internet access, I’ll check the route table for default route to NAT gateway. Then confirm NAT is in a public subnet with an EIP and its route table points to the IGW. I’ll verify NACL and SG egress and confirm DNS resolution. Once fixed, I’ll keep it in IaC and add checks so NAT/route issues are detected early.”

16) DevOps: Secrets Worked Yesterday, Today App Fails Auth

1. Scenario
After a restart, app cannot authenticate to DB. It worked yesterday.

2. Question
“How do you debug secret/config issues?”

3. Evaluates
Secret lifecycle, rotation, env consistency.

4. Steps

Check if secret changed/rotated

Verify app is reading correct secret name/version

Check permissions to read secret

Verify config in deployment

Test connectivity manually from pod/instance

5. Tools
AWS Secrets Manager/SSM, K8s secrets, IAM roles, app logs.

6. Root causes
Secret rotation not handled, wrong secret reference, permission removed, config drift.

7. Prevention
Standard secret rotation strategy, automated reload, config audits, IaC.

8. Spoken answer
“I’ll check logs to confirm auth failure and verify if secrets were rotated. Then I’ll confirm the application is referencing the correct secret/version and has IAM permission. I’ll test DB connection from inside the runtime. After fixing, I’ll ensure rotation is handled properly and avoid config drift using IaC and audits.”

17) Kubernetes: HPA Not Scaling Even When CPU Is High

1. Scenario
CPU is 90% but HPA is not scaling.

2. Question
“What do you check in HPA failures?”

3. Evaluates
Metrics server, requests/limits, HPA config.

4. Steps

Check HPA status/events

Confirm metrics-server working

Ensure CPU requests set (HPA needs requests)

Check scale limits and target utilization

5. Commands

kubectl get hpa
kubectl describe hpa <name>
kubectl top pods
kubectl top nodes


6. Root causes
No metrics-server, missing CPU requests, wrong target, max replicas reached.

7. Prevention
Baseline requests/limits, metrics health checks, HPA testing.

8. Spoken answer
“I’ll inspect kubectl describe hpa to see why it’s not scaling. Usually metrics-server issues or missing CPU requests cause this. I’ll verify metrics availability using kubectl top. Then ensure CPU requests are defined and HPA targets are correct. Finally, I’ll test HPA behavior in staging and keep metrics-server monitored.”

18) CI/CD: Docker Image Pull Fails in Production

1. Scenario
New pods fail with ImagePullBackOff.

2. Question
“How do you troubleshoot image pull failures?”

3. Evaluates
Registry auth, image tag, network, permissions.

4. Steps

Check pod events

Validate image name/tag exists

Check registry credentials (ECR token, imagePullSecret)

Verify node can reach registry endpoints

Check IAM role permissions for ECR

5. Commands/tools

kubectl describe pod <pod>
kubectl get events
aws ecr describe-images --repository-name <repo>


6. Root causes
Wrong tag, missing push, expired auth, IAM missing, private endpoint/DNS issue.

7. Prevention
Immutable tags, deploy only after push validation, ECR permissions via roles, pre-pull tests.

8. Spoken answer
“I’ll start with kubectl describe pod to see the exact pull error. Then I’ll confirm the image tag exists in the registry. If it’s auth, I’ll fix ECR permissions or imagePullSecret and ensure nodes can reach ECR endpoints. After recovery, I’ll enforce immutable tags and make the pipeline verify image availability before deployment.”

19) AWS: S3 Access Denied After Policy Change

1. Scenario
App suddenly gets 403 AccessDenied on S3 uploads after a change.

2. Question
“How do you debug S3 permission issues?”

3. Evaluates
IAM + bucket policy + KMS + block public access.

4. Steps

Identify which identity is used (role/user)

Review IAM policy permissions (PutObject, ListBucket)

Check bucket policy conditions

Check KMS permissions if SSE-KMS

Verify endpoint policy if using VPC endpoint

5. Tools
IAM policy simulator, CloudTrail, S3 bucket policy, KMS key policy.

6. Root causes
Explicit deny in bucket policy, missing KMS permissions, wrong prefix condition, endpoint policy deny.

7. Prevention
Change review, policy tests, least privilege templates, automated checks.

8. Spoken answer
“I’ll confirm the role used by the app and then simulate permissions using IAM policy simulator. I’ll check both IAM policy and bucket policy for explicit denies and conditions. If encryption uses KMS, I’ll ensure the role can use the key. If traffic goes via VPC endpoint, I’ll review endpoint policy. After fixing, I’ll add policy tests and change controls.”

20) Monitoring + Ops: Incident Happened, But No Useful Logs

1. Scenario
Service had a 20-minute outage, but logs are missing or incomplete. Hard to find root cause.

2. Question
“How do you design observability to avoid this situation?”

3. Evaluates
Logging, metrics, tracing, retention, correlation IDs.

4. Steps

Ensure logs are centralized and retained

Add structured logs + correlation/request IDs

Add key metrics: error rate, latency, saturation

Add tracing for distributed services

Ensure alerts link to dashboards and runbooks

5. Tools
CloudWatch Logs, ELK/OpenSearch, Prometheus/Grafana, X-Ray/Jaeger.

6. Root causes
No central logging, short retention, no correlation IDs, no trace.

7. Prevention
Standard observability baseline, retention policies, sampling strategy, incident runbooks.

8. Spoken answer
“If we can’t debug due to missing logs, the fix is observability. I’ll centralize logs with proper retention, use structured logging and correlation IDs, and create dashboards for latency, errors, and saturation. For microservices, I’ll add tracing to see where time is spent. Finally, I’ll connect alerts to runbooks and dashboards so incidents become faster to resolve.”

If you want, I can also generate:

“Only Linux (50 scenarios)” or “Only AWS (50 scenarios)”

A mock interview script (interviewer questions + follow-up traps)

A PDF format (placement-ready)

make scenario in easy to understand and interviewer style 

Great 👍
Below is a simplified, interviewer-style version of real-time scenario questions.
Language is easy English, answers are spoken like a candidate in interview, and flow is exactly how interviewers expect.

This is ideal for students, fresh DevOps engineers, and mock interviews at CloudBlitz.

✅ REAL-TIME LINUX / AWS / DEVOPS
Interview Style Scenario Questions & Answers (Easy Language)
🟦 1. Disk Full – Application Down (Linux)
👨‍💼 Interviewer:

Your production server disk becomes 100% full and application stops working. What will you do?

👨‍💻 Candidate Answer:

First, I will check which disk is full using:

df -h


Then I will find which folder is taking more space:

du -sh /var/* | sort -h


If large log files are present, I will safely truncate them instead of deleting:

truncate -s 0 /var/log/app.log


After freeing space, I will restart the application and confirm service is up.

To prevent this, I will enable log rotation and disk usage alerts.

🟦 2. High Load but CPU is Normal (Linux)
👨‍💼 Interviewer:

Server load is very high but CPU usage is low. Why and how will you troubleshoot?

👨‍💻 Candidate Answer:

High load with low CPU usually means processes are waiting for disk or network.

I will check IO wait using:

vmstat 1
iostat


If disk IO is high, I will find which process is using disk heavily and optimize or restart it.

I will also check if any NFS or storage issue exists.

🟦 3. Website Not Opening but Server is Reachable
👨‍💼 Interviewer:

Server is reachable on SSH but website is not opening. What will you check?

👨‍💻 Candidate Answer:

First, I will check if the web service is running:

systemctl status nginx


Then I will check if the port is listening:

ss -tulnp | grep 80


If not running, I will check logs and restart the service.

I will also verify firewall rules.

🟦 4. Memory Usage Increasing Daily
👨‍💼 Interviewer:

Memory usage increases every day without reboot. What does it indicate?

👨‍💻 Candidate Answer:

It usually indicates memory leak in application.

I will check memory usage using:

free -h
top


Then I will find which process is consuming more memory:

ps aux --sort=-%mem | head


If same process grows continuously, application team needs to fix it.

🟦 5. Cannot SSH After Reboot (AWS/Linux)
👨‍💼 Interviewer:

After reboot, EC2 is not reachable. How will you fix it?

👨‍💻 Candidate Answer:

I will connect using EC2 console or serial console.

Then I will check network settings:

ip a
ip route


I will verify SSH service is running and check boot logs.

Common reasons are network misconfiguration or disk mount failure.

🟦 6. Auto Scaling Not Launching New EC2 (AWS)
👨‍💼 Interviewer:

Traffic increased but Auto Scaling is not launching new instances. What will you do?

👨‍💻 Candidate Answer:

I will check Auto Scaling activity history to see error reason.

I will verify:

Subnet has free IPs

Instance type availability

AWS quota limits

Launch template configuration

If required, I will change instance type or increase quota.

🟦 7. AWS Bill Suddenly Increased
👨‍💼 Interviewer:

Your AWS bill doubled suddenly. How will you find the reason?

👨‍💻 Candidate Answer:

I will open AWS Cost Explorer and check which service increased cost.

Then I will identify the resource causing it and stop unnecessary usage.

Common reasons are NAT Gateway traffic, log storage, snapshots, or autoscaling.

I will also configure budget alerts.

🟦 8. Deployment Successful but App Not Working (DevOps)
👨‍💼 Interviewer:

Pipeline succeeded but application is broken in production. What will you do?

👨‍💻 Candidate Answer:

First, I will rollback to last working version to restore service.

Then I will check logs, environment variables, and configuration changes.

After fixing the issue, I will add smoke tests in pipeline to prevent this.

🟦 9. Container Restarting Continuously (Docker/K8s)
👨‍💼 Interviewer:

A container keeps restarting. How will you troubleshoot?

👨‍💻 Candidate Answer:

I will check container logs:

kubectl logs pod-name --previous


Then I will check pod details:

kubectl describe pod pod-name


Common reasons are wrong config, missing secrets, memory limit exceeded, or health check failure.

🟦 10. Kubernetes Service Not Reachable
👨‍💼 Interviewer:

Pods are running but service is not accessible. What will you check?

👨‍💻 Candidate Answer:

I will check if service selector matches pod labels:

kubectl describe svc my-service
kubectl get endpoints my-service


If endpoints are empty, selector is wrong.

I will also check targetPort and network policies.

🟦 11. ImagePullBackOff Error
👨‍💼 Interviewer:

Pods fail with ImagePullBackOff. What does it mean?

👨‍💻 Candidate Answer:

It means Kubernetes cannot download the image.

I will verify image name and tag, registry permissions, and network access.

I will also check pod events.

🟦 12. High RDS CPU (AWS)
👨‍💼 Interviewer:

Database CPU is high and application is slow. How will you troubleshoot?

👨‍💻 Candidate Answer:

I will check CloudWatch metrics and Performance Insights.

I will identify slow queries and optimize them.

If required, I will scale DB temporarily.

🟦 13. Alerts Trigger Too Frequently (Monitoring)
👨‍💼 Interviewer:

Your monitoring sends too many alerts even when system is okay. What will you do?

👨‍💻 Candidate Answer:

I will tune alert thresholds and add time delay.

Only real business-impact alerts should page engineers.

🟦 14. AWS Access Key Exposed
👨‍💼 Interviewer:

Someone committed AWS key in GitHub. What action will you take?

👨‍💻 Candidate Answer:

I will immediately disable the key.

I will check CloudTrail for misuse.

Then rotate credentials and enable secret scanning.

🟦 15. Private EC2 Cannot Access Internet
👨‍💼 Interviewer:

EC2 in private subnet cannot access internet. What will you check?

👨‍💻 Candidate Answer:

I will check NAT Gateway and route table.

Private subnet must route traffic to NAT.


----------------------------------------------------------
------------------------------------------------------------------------------


##### Devops 


1) Kubernetes: Pods Running but Service Not Reachable

1. Scenario
New release deployed. Pods show Running, but customers get timeout. Business impact: checkout not working.

2. Interviewer asks
“Pods are running but service is not reachable. What will you check first?”

3. Evaluates
Service/selector understanding, endpoints, ports, readiness, network.

4. Steps

Check service and endpoints

Verify selector matches pod labels

Verify targetPort matches container port

Test from inside cluster using curl

Check NetworkPolicy / Ingress / security groups (EKS)

5. Commands/tools

kubectl get svc -n <ns>
kubectl describe svc <svc> -n <ns>
kubectl get endpoints <svc> -n <ns>
kubectl get pods -n <ns> --show-labels
kubectl exec -it <pod> -n <ns> -- curl -v http://<svc>:<port>/health


6. Root causes
Wrong service selector, wrong port mapping, readiness failing, network policy blocking.

7. Immediate fix
Fix selector/port, redeploy service; temporarily route traffic to previous stable service.

8. Prevention
Helm chart validation, standard labels, automated post-deploy service checks.

9. Spoken answer
“I’ll start with service endpoints. If endpoints are empty, the selector or readiness is wrong. I’ll confirm pod labels and service selector match, then verify service targetPort matches container port. I’ll also test from within the cluster using curl. If NetworkPolicy or Ingress rules block traffic, I’ll adjust them. I’ll fix the config and redeploy, and add post-deploy connectivity checks to prevent repeat.”

2) Kubernetes: CrashLoopBackOff After Config Change

1. Scenario
After applying a config map change, pods go into CrashLoopBackOff. Business impact: API down.

2. Interviewer asks
“Pod is CrashLoopBackOff. How do you debug quickly?”

3. Evaluates
Logs, describe, env/config, exit codes, rollback decision.

4. Steps

Check pod events and reason

Read previous container logs

Verify config/secret values

Roll back if impact is high

5. Commands

kubectl describe pod <pod> -n <ns>
kubectl logs <pod> -n <ns> --previous
kubectl get cm,secret -n <ns>
kubectl rollout undo deploy/<deploy> -n <ns>


6. Root causes
Bad config value, missing env var, wrong secret key, app fails on startup.

7. Immediate fix
Rollback deployment or revert config map; restart pods.

8. Prevention
Config validation, staging tests, feature flags, safe rollout (canary).

9. Spoken answer
“I’ll run kubectl describe pod to see events and the exact failure. Then I’ll check kubectl logs --previous for the crash reason. If it’s a config/secret issue, I’ll revert to the last good config. Since it’s production impact, I’ll rollback the deployment immediately and then fix safely in staging before redeploying.”

3) Kubernetes: HPA Not Scaling During Traffic Spike

1. Scenario
Traffic increased, CPU is high, but HPA is not scaling. Users see slow response.

2. Interviewer asks
“HPA is configured but not scaling. What do you check?”

3. Evaluates
Metrics server, CPU requests, HPA limits, max replicas.

4. Steps

Check HPA status and events

Confirm metrics are available

Ensure CPU requests exist

Check maxReplicas and scaling policies

5. Commands

kubectl get hpa -n <ns>
kubectl describe hpa <hpa> -n <ns>
kubectl top pods -n <ns>
kubectl describe deploy <deploy> -n <ns> | grep -A5 Requests


6. Root causes
Metrics-server down, no CPU requests, max replicas reached, wrong target utilization.

7. Immediate fix
Set CPU requests, fix metrics-server, temporarily scale replicas manually.

8. Prevention
HPA testing, monitor metrics-server, baseline requests/limits.

9. Spoken answer
“I’ll check kubectl describe hpa to see why scaling is blocked. If metrics are missing, kubectl top will fail—then metrics-server needs fixing. If CPU requests are not set, HPA won’t work properly, so I’ll add requests and redeploy. For immediate relief, I’ll manually scale while fixing the root issue.”

4) Kubernetes: Ingress Works for Some Users, Fails for Others

1. Scenario
Some users can access site, others get 504. Business impact: partial outage.

2. Interviewer asks
“Intermittent Ingress 504. How will you troubleshoot?”

3. Evaluates
Ingress controller logs, upstream timeouts, target health, DNS, LB.

4. Steps

Check ingress controller logs

Check backend service endpoints

Validate readiness and pod health

Review timeout settings (Ingress annotations)

Check LB target group health (if ALB ingress)

5. Tools/commands

kubectl get ingress -n <ns>
kubectl describe ingress <ing> -n <ns>
kubectl logs -n ingress-nginx deploy/ingress-nginx-controller
kubectl get endpoints <svc> -n <ns>


6. Root causes
Backend slow, wrong timeout, uneven pod health, DNS/LB issues.

7. Immediate fix
Increase timeouts if needed, scale backend, fix unhealthy pods.

8. Prevention
Proper readiness checks, SLO alerts, load testing, correct timeouts.

9. Spoken answer
“I’ll check ingress controller logs to see if it’s upstream timeout or connection reset. Then I’ll confirm service endpoints are healthy and pods are ready. If backend is slow, I’ll scale pods and check DB latency. If timeouts are too low, I’ll tune ingress timeout annotations. Then I’ll add alerts on 5xx and latency so we catch it earlier.”

------------------- DOCKER -------------------


5) Docker: Container Restarts After Deploy (OOMKilled)

1. Scenario
After new image release, container restarts frequently. Users see random failures.

2. Interviewer asks
“Container restarts again and again. How do you confirm OOM and fix?”

3. Evaluates
Memory limits, logs, resource tuning.

4. Steps

Check restart reason (OOMKilled)

Check logs and memory usage

Increase memory limit or fix leak

Rollback if required

5. Commands/tools

docker ps -a
docker logs <container>
docker inspect <container> | grep -i oom
docker stats


6. Root causes
Memory leak, low memory limit, heavy workload, larger payload.

7. Immediate fix
Increase memory limit, rollback to previous image.

8. Prevention
Load testing, define resource limits properly, profiling, monitoring.

9. Spoken answer
“I’ll confirm the restart reason using docker inspect and check logs. If it’s OOMKilled, I’ll check memory usage via docker stats. For production recovery I’ll either increase memory limit or rollback the release. Long term, I’ll profile memory usage and set proper limits based on real load tests.”

6) Docker: Image Works Locally, Fails in Server

1. Scenario
Same image runs on developer laptop but fails on prod host. Impact: deployment blocked.

2. Interviewer asks
“Why container works locally but fails in prod?”

3. Evaluates
Env differences, architecture, permissions, file paths.

4. Steps

Check environment variables

Check mount paths and permissions

Confirm CPU architecture (amd64/arm64)

Check dependency on local files

5. Commands

docker logs <id>
docker inspect <id>
uname -a
docker image inspect <image> | grep Architecture


6. Root causes
Missing env vars, wrong volume path, permission issues, architecture mismatch.

7. Immediate fix
Fix env/volumes, rebuild multi-arch image, adjust permissions.

8. Prevention
Use same base images, run staging on similar infra, container contract checks.

9. Spoken answer
“I’ll compare prod vs local environment—env vars, volumes, permissions. I’ll check logs first, then inspect mounts and user permissions. I’ll also confirm the server architecture and the image architecture. Once identified, I’ll fix the image or runtime config and ensure staging environment matches production.”

------------------- JENKINS -------------------

7) Jenkins: Pipeline Green but Wrong Version Deployed

1. Scenario
Pipeline is successful, but production is still running old code. Business impact: bug not fixed.

2. Interviewer asks
“Pipeline succeeded but correct version is not in production. How do you debug?”

3. Evaluates
Artifact versioning, tag strategy, deployment verification.

4. Steps

Confirm which commit/tag was built

Confirm image tag pushed to registry

Confirm deployment uses same tag

Check if deployment step skipped / cached

Verify rollout history

5. Tools/commands
Jenkins console logs, Git commit, registry tags, Kubernetes:

kubectl describe deploy <deploy> -n <ns> | grep -i image
kubectl rollout history deploy/<deploy> -n <ns>


6. Root causes
Using latest tag, wrong branch built, cache issue, deploy step uses old artifact.

7. Immediate fix
Deploy correct tag/commit, redeploy.

8. Prevention
Immutable tags, build metadata, post-deploy verification, “no latest” policy.

9. Spoken answer
“I’ll check Jenkins logs to confirm which commit was built and what tag was pushed. Then I’ll verify the production deployment is using that exact tag. If we used latest, it can cause confusion—so I’ll redeploy with an immutable tag and verify via rollout history. Long term I’ll enforce tag immutability and add post-deploy checks.”

8) Jenkins: Pipeline Fails Only on One Agent

1. Scenario
Build passes on agent-1 but fails on agent-2. Releases getting delayed.

2. Interviewer asks
“Same pipeline fails on specific Jenkins node. What will you check?”

3. Evaluates
Agent consistency, tools, permissions, disk.

4. Steps

Compare tool versions (java, node, docker)

Check workspace permissions

Check disk space and memory

Check network/proxy settings

5. Commands/tools
Jenkins node info + on agent:

java -version
node -v
docker version
df -h
env | sort


6. Root causes
Different tool versions, low disk, permission issues, proxy mismatch.

7. Immediate fix
Take faulty agent offline, run on healthy node, fix agent baseline.

8. Prevention
Golden agent images, containerized build agents, configuration management.

9. Spoken answer
“I’ll first isolate by running the same job on another agent. If it fails only on one node, I’ll compare tool versions, environment variables, disk space, and permissions. For quick recovery I’ll mark that agent offline and continue releases. Long term I’ll standardize agents using immutable images or Docker-based agents.”

9) Jenkins: Secrets Leaked in Console Output

1. Scenario
A build printed credentials in Jenkins console logs. Security incident.

2. Interviewer asks
“What immediate actions will you take and how will you prevent it?”

3. Evaluates
Security response, secret handling, masking.

4. Steps

Rotate compromised secrets immediately

Remove logs/access if needed

Fix pipeline to mask secrets

Move secrets to Jenkins credentials / secret manager

Add scanning and review

5. Tools
Jenkins Credentials, audit logs, secret manager.

6. Root causes
Using echo $SECRET, scripts printing env, no masking.

7. Immediate fix
Rotate secrets, restrict access, remove leaked logs if policy allows.

8. Prevention
Credentials binding, masking, avoid printing, pipeline linting.

9. Spoken answer
“First I’ll rotate the exposed credentials and check audit logs for misuse. Then I’ll fix the pipeline to never print secrets and use Jenkins credentials binding with masking enabled. Long term, I’ll move secrets to a secret manager and enforce code review and scanning on pipeline changes.”

------------------- TERRAFORM -------------------

10) Terraform: terraform apply Deletes Resources Unexpectedly

1. Scenario
During apply, Terraform plan shows it will destroy critical resources. Release blocked.

2. Interviewer asks
“Terraform wants to destroy resources. What will you do?”

3. Evaluates
State understanding, plan review, safety.

4. Steps

Stop apply, review plan carefully

Check if resource name/module changed

Check state drift and import needs

Verify workspace and backend state

Use terraform state commands if needed

5. Commands/tools

terraform plan
terraform state list
terraform state show <res>
terraform workspace show
terraform refresh


6. Root causes
Resource renaming, wrong workspace, state file mismatch, manual changes in AWS.

7. Immediate fix
Do not apply. Fix code/state: import, move state, correct workspace/backend.

8. Prevention
Mandatory plan review, remote state locking, tagging + drift detection, change controls.

9. Spoken answer
“If Terraform plan shows destroy for critical resources, I’ll stop immediately and review why. Often it’s a rename or wrong workspace. I’ll verify backend and workspace and check state entries. If resources exist but not in state, I’ll import them or move state properly. I’ll only apply after plan is safe, and I’ll enforce plan approvals and state locking.”

11) Terraform: State Lock Issue Blocks Deployment

1. Scenario
Terraform says state is locked. No one is running apply now. Deployment blocked.

2. Interviewer asks
“How do you handle Terraform state lock safely?”

3. Evaluates
State locking, safe unlock, team coordination.

4. Steps

Confirm no ongoing pipeline/apply

Identify lock holder from backend (DynamoDB etc.)

If stale, force-unlock carefully

Re-run plan

5. Commands

terraform plan
terraform force-unlock <LOCK_ID>


6. Root causes
Previous job crashed, network failure, pipeline killed.

7. Immediate fix
Force unlock after confirming it’s stale; rerun apply.

8. Prevention
Reliable CI, retries, proper backend (S3 + DynamoDB), job timeouts.

9. Spoken answer
“I’ll first confirm no one is currently running Terraform. Then I’ll check the lock details from backend and if it’s stale, I’ll use terraform force-unlock with the lock ID. After unlocking, I’ll run plan again before applying. Long term I’ll improve pipeline reliability and ensure proper locking with S3+DynamoDB.”

12) Terraform: Changes Not Detected Even After Code Update

1. Scenario
You changed infra code but terraform plan shows “no changes”. But you are sure changes exist.

2. Interviewer asks
“What can cause Terraform to show no changes?”

3. Evaluates
Variables, workspaces, modules, targeting.

4. Steps

Confirm correct workspace and backend

Confirm variable files are correct

Ensure module version updated (if using registry/git ref)

Remove wrong -target usage

Check if change is in unused resource

5. Commands

terraform workspace show
terraform validate
terraform plan -var-file=prod.tfvars


6. Root causes
Wrong workspace, wrong tfvars, module ref pinned, change not referenced.

7. Immediate fix
Use correct workspace/tfvars, update module ref, re-run plan.

8. Prevention
Standard pipeline per env, lock module versions intentionally, review process.

9. Spoken answer
“I’ll first confirm I’m in the correct workspace and using the right tfvars. Many times people run plan in dev workspace by mistake. If modules are used, I’ll confirm module source/ref is updated. I’ll avoid target plans unless needed. Once corrected, plan should show expected changes.”

## 13) Kubernetes + Terraform: EKS Created but Nodes Not Joining

1. Scenario
Terraform created EKS cluster, but worker nodes don’t join. Pods stay Pending. Impact: platform down.

2. Interviewer asks
“EKS cluster is up but nodes not joining. How do you debug?”

3. Evaluates
EKS node IAM, networking, aws-auth, security groups.

4. Steps

Check node group status and EC2 instances

Check IAM role and policies for nodes

Check aws-auth configmap

Verify subnet routing and security groups

Check CNI status

5. Tools/commands
AWS EKS console, CloudWatch logs, kubectl:

kubectl get nodes
kubectl -n kube-system get cm aws-auth -o yaml
kubectl -n kube-system get pods


6. Root causes
Missing IAM policies, wrong security groups, aws-auth not updated, subnet issues.

7. Immediate fix
Fix IAM + aws-auth; ensure correct subnets/SG; restart node group.

8. Prevention
Use proven EKS Terraform modules, automated aws-auth management, staging test.

9. Spoken answer
“I’ll check node group status and EC2 instances first. If nodes exist but don’t join, it’s usually IAM or aws-auth mapping. I’ll verify node role policies and check aws-auth configmap. I’ll also confirm subnet routing and security groups allow required traffic. Once fixed, nodes should register and pods will schedule. Long term I’ll standardize EKS module and test changes in staging.”

## 14) Jenkins + Terraform: Pipeline Applied to Wrong Environment

1. Scenario
A Jenkins job applied Terraform changes to prod instead of staging. High risk incident.

2. Interviewer asks
“How do you prevent Terraform from applying to wrong environment?”

3. Evaluates
Safety controls, approvals, workspace discipline.

4. Steps

Stop pipeline immediately

Identify what changed in prod (plan/apply logs)

Rollback if needed

Implement guardrails: approvals, separate credentials, separate state, policy checks

5. Tools
Jenkins approvals, separate AWS accounts/roles, Terraform workspaces/backends, OPA/Sentinel.

6. Root causes
Same credentials/state used for all env, manual parameter selection, no approvals.

7. Immediate fix
Stop job, revert changes carefully using plan, restore known good state.

8. Prevention
Separate AWS accounts, separate pipelines, manual approvals for prod, enforce policy.

9. Spoken answer
“I’ll stop the pipeline and assess exactly what changed using the plan/apply output. If needed, I’ll rollback safely. Long term, I’ll enforce environment separation—different AWS roles/accounts, different state backends, and mandatory manual approval for prod. I’ll also add policy checks so prod apply cannot happen without proper gate.”

## 15) Docker + Kubernetes: Node Disk Full Due to Images

1. Scenario
K8s nodes become NotReady due to disk pressure. Root: too many old Docker images. Impact: pods evicted.

2. Interviewer asks
“Node disk pressure due to images. How do you fix and prevent?”

3. Evaluates
Node maintenance, image pruning, eviction thresholds.

4. Steps

Confirm DiskPressure on node

Identify disk usage on node

Prune unused images (carefully)

Adjust image garbage collection settings

Improve image size and deployment frequency

5. Tools/commands

kubectl describe node <node> | grep -i pressure
# On node:
df -h
docker system df
docker image prune -a


6. Root causes
Large images, frequent deploys, no pruning, no GC tuning.

7. Immediate fix
Clean up images and logs; add capacity.

8. Prevention
Smaller images, node GC tuning, monitoring, separate partitions.

9. Spoken answer
“I’ll confirm DiskPressure in kubectl describe node. Then on the node I’ll check df -h and docker system df to see image usage. For immediate recovery I’ll prune unused images carefully and free space, then ensure scheduling returns. Long term I’ll reduce image size, tune garbage collection, and add alerts for node disk usage.”

## 16) Jenkins: Plugin Update Broke Pipelines

1. Scenario
Jenkins plugins updated. Suddenly multiple pipelines fail. Delivery stopped.

2. Interviewer asks
“After plugin update, pipelines fail. How do you recover fast?”

3. Evaluates
Rollback strategy, change management.

4. Steps

Identify failing plugin from logs

Rollback plugin or restore Jenkins from backup

Use staging Jenkins for plugin testing

Freeze updates during release windows

5. Tools
Jenkins system logs, plugin manager, backup/restore, configuration as code.

6. Root causes
Plugin incompatibility, dependency changes, scripted pipeline break.

7. Immediate fix
Rollback plugin version, restore from snapshot/backup.

8. Prevention
Test updates in staging, version pinning, backup plan, change windows.

9. Spoken answer
“I’ll check Jenkins logs to identify which plugin update caused failures. For quick recovery, I’ll rollback that plugin or restore Jenkins from a backup/snapshot. Then I’ll test plugin updates in staging before production and pin working versions. This avoids downtime due to uncontrolled updates.”