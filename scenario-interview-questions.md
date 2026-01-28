# Linux Scenarios

## Linux: Disk 100% Full, App Down

## Scenario
At 2 AM, payments API started returning 500. Alert: /var is 100% full. Logging service also stopped.

## Interview question
"How will you troubleshoot a disk-full incident and restore service safely?"

## What interviewer evaluates
Prioritization, safe cleanup, log handling, prevention.

## Troubleshooting approach
- Confirm which mount is full (df -h)
- Identify top directories (du)
- Find large files/logs/core dumps (find)
- Free space safely (truncate logs, rotate logs, remove old artifacts)
- Restart impacted services and confirm health

## Commands / tools
```
df -h
df -i
du -sh /var/* | sort -h
find /var -type f -size +500M -ls
lsof +L1
truncate -s 0 /var/log/<biglog>
journalctl --vacuum-time=7d
systemctl restart <service>
```

## Root cause possibilities
- Log flood, debug mode enabled, core dumps, stuck retry loops, no log rotation, inode exhaustion.

## Prevention / best practices
- Logrotate, retention policy, alert on 70/80/90%, separate partition for logs, cap app logs, central logging.

## Sample spoken answer
"First I'll run df -h to see which mount is full and confirm inode with df -i. Then I'll locate the largest directories using du and identify big files using find. If it's logs, I'll truncate or rotate them safely, and check deleted-but-open files via lsof +L1. Once space is recovered, I'll restart affected services and verify API health. Finally I'll add proper log rotation and alerts so this doesn't repeat."

## Linux: High Load Average but CPU Not High

## Scenario
Server load average is 50, but CPU usage is only 20%. Application is slow, users complaining.

## Interview question
"How do you troubleshoot high load average when CPU isn't the bottleneck?"

## What interviewer evaluates
Understanding load vs CPU, I/O bottlenecks, process analysis.

## Troubleshooting approach
- Check load average (uptime)
- Examine CPU, memory, I/O (top, htop)
- Identify blocking processes (ps, strace)
- Check disk I/O (iostat, iotop)
- Network issues (netstat, ss)
- Zombie processes or thread contention

## Commands / tools
```
uptime
top -H
iostat -x 1
iotop
ps auxf
strace -p <pid>
vmstat 1
```

## Root cause possibilities
- Disk I/O saturation, network bottlenecks, memory swapping, zombie processes, thread locks, high context switching.

## Prevention / best practices
- Monitor I/O metrics, optimize queries, use SSDs, tune kernel parameters, load balancing.

## Sample spoken answer
"I'll start by checking uptime for load average, then use top to see CPU and memory. If load is high but CPU low, it's likely I/O. I'll run iostat to check disk utilization and iotop for per-process I/O. Then examine processes with ps and strace for blocking calls. If it's memory, check vmstat for swapping. Prevention includes monitoring I/O and optimizing storage."

## Linux: Server Reachable but Port Closed Suddenly

## Scenario
SSH and ping work, but web app on port 80/443 is down. Firewall rules unchanged.

## Interview question
"How do you troubleshoot when a service port is suddenly inaccessible?"

## What interviewer evaluates
Network troubleshooting, service status, logs analysis.

## Troubleshooting approach
- Check service status (systemctl)
- Verify port listening (netstat, ss)
- Firewall rules (iptables, ufw)
- SELinux/AppArmor (sestatus, apparmor_status)
- Application logs
- Resource limits (ulimit)

## Commands / tools
```
systemctl status <service>
netstat -tlnp | grep :80
ss -tlnp | grep :80
iptables -L
ufw status
journalctl -u <service>
dmesg | tail
```

## Root cause possibilities
- Service crashed, port conflict, firewall change, SELinux denial, resource exhaustion, kernel issues.

## Prevention / best practices
- Monitoring service health, log aggregation, automated restarts, security policies review.

## Sample spoken answer
"First, check if the service is running with systemctl. If yes, verify if it's listening on the port with ss. Check firewall with ufw or iptables. Look at service logs with journalctl. If SELinux, check audit logs. Restart service and monitor."

## Linux: No Space Left on Device but df Shows Free Space

## Scenario
Application fails with "No space left on device" but df -h shows plenty of free space.

## Interview question
"How do you handle 'No space left on device' when disk has free space?"

## What interviewer evaluates
Inode exhaustion, file system issues.

## Troubleshooting approach
- Check inodes (df -i)
- Find inode usage (find, ls)
- Large number of small files
- File system corruption (fsck)
- Quotas (quota)

## Commands / tools
```
df -i
find /path -type f | wc -l
ls -la /path | head
tune2fs -l /dev/sda1
fsck /dev/sda1
quota -u <user>
```

## Root cause possibilities
- Inode exhaustion from many small files, file system full of inodes, corruption, user quotas.

## Prevention / best practices
- Monitor inode usage, avoid deep directory structures, use larger inode file systems.

## Sample spoken answer
"Even though df shows space, it might be inodes. Run df -i to check. If inodes are full, find directories with many files using find. Check for corruption with fsck. Prevention: monitor inodes and plan for file growth."

## Linux: High Memory Usage but No Processes Using It

## Scenario
Memory usage is 95%, but top shows no single process using much memory.

## Interview question
"How do you troubleshoot high memory usage with no obvious culprit?"

## What interviewer evaluates
Memory leak detection, kernel buffers, shared memory.

## Troubleshooting approach
- Check memory breakdown (free, vmstat)
- Kernel buffers/cache (slabtop)
- Shared memory (ipcs)
- Memory leaks (valgrind, if applicable)
- Swap usage

## Commands / tools
```
free -h
vmstat -s
slabtop
ipcs -m
cat /proc/meminfo
ps aux --sort=-%mem | head
```

## Root cause possibilities
- Kernel caches, shared memory segments, memory fragmentation, leaks in kernel modules.

## Prevention / best practices
- Monitor memory trends, tune kernel parameters, use memory profiling tools.

## Sample spoken answer
"Use free to see buffers/cache. If high, it's kernel. slabtop shows kernel memory usage. Check ipcs for shared memory. Look at /proc/meminfo for details. Prevention: monitor and optimize kernel settings."

# AWS Scenarios

## AWS: EC2 Auto Scaling Not Launching Instances

## Scenario
Auto scaling group not scaling out during high CPU, instances not launching.

## Interview question
"How do you troubleshoot Auto Scaling not launching instances?"

## What interviewer evaluates
AWS service knowledge, IAM permissions, limits.

## Troubleshooting approach
- Check scaling policies and alarms (CloudWatch)
- IAM permissions for Auto Scaling
- Service limits (EC2 limits)
- Subnet capacity, security groups
- ASG configuration (min/max/desired)

## Commands / tools
```
aws autoscaling describe-auto-scaling-groups
aws cloudwatch describe-alarms
aws ec2 describe-instances --filters "Name=instance-state-name,Values=pending"
aws iam simulate-principal-policy
```

## Root cause possibilities
- IAM permissions missing, CloudWatch alarms misconfigured, EC2 limits reached, subnet full, launch template issues.

## Prevention / best practices
- Monitor ASG events, set up notifications, review IAM policies, plan capacity.

## Sample spoken answer
"Check CloudWatch alarms and scaling policies. Verify IAM roles have autoscaling permissions. Check EC2 limits and subnet capacity. Look at ASG activity history for errors."

## AWS: Sudden Cost Spike Overnight

## Scenario
AWS bill increased 10x overnight, no major changes deployed.

## Interview question
"How do you investigate sudden AWS cost increases?"

## What interviewer evaluates
Cost monitoring, resource usage analysis.

## Troubleshooting approach
- Check Cost Explorer and billing alerts
- Identify services with cost spikes (EC2, S3, Lambda)
- Check for unused resources (EBS, snapshots)
- Data transfer costs, cross-region traffic
- Security incidents (crypto mining)

## Commands / tools
```
aws ce get-cost-and-usage --time-period Start=2023-01-01,End=2023-01-02
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"
aws s3 ls s3://bucket --recursive | wc -l
aws lambda list-functions
```

## Root cause possibilities
- Resource leaks, data transfer spikes, unused EBS volumes, Lambda cold starts, compromised instances.

## Prevention / best practices
- Cost allocation tags, budgets and alerts, regular cleanup, monitoring tools like CloudWatch.

## Sample spoken answer
"Use Cost Explorer to see which services spiked. Check for running instances, large S3 buckets, Lambda invocations. Look for unused resources. Set up cost alerts."

## AWS: ALB Healthy but Users Still Fail

## Scenario
ALB shows all targets healthy, but users getting 502/504 errors.

## Interview question
"How do you troubleshoot ALB issues when targets are healthy?"

## What interviewer evaluates
Load balancer configuration, network issues.

## Troubleshooting approach
- Check ALB access logs
- Target group health checks
- Security groups (allow ALB traffic)
- Network ACLs, route tables
- Application response times
- ALB capacity

## Commands / tools
```
aws elbv2 describe-target-health --target-group-arn <arn>
aws elbv2 describe-load-balancers
aws ec2 describe-security-groups
tail -f /var/log/nginx/access.log
```

## Root cause possibilities
- Health check misconfiguration, security groups blocking, slow application responses, ALB throttling.

## Prevention / best practices
- Proper health checks, monitoring response times, security group reviews.

## Sample spoken answer
"Check ALB logs for errors. Verify health checks match app endpoints. Ensure security groups allow traffic from ALB. Check app logs for slow responses."

## AWS: RDS CPU High and App Slow

## Scenario
RDS CPU utilization at 100%, application queries timing out.

## Interview question
"How do you troubleshoot high RDS CPU usage?"

## What interviewer evaluates
Database performance, query optimization.

## Troubleshooting approach
- Check RDS metrics (CloudWatch)
- Identify slow queries (Performance Insights)
- Check connection count
- Review database configuration
- Index issues, query plans

## Commands / tools
```
aws rds describe-db-instances
aws cloudwatch get-metric-statistics --namespace AWS/RDS --metric-name CPUUtilization
SHOW PROCESSLIST;
EXPLAIN SELECT * FROM table;
```

## Root cause possibilities
- Inefficient queries, missing indexes, high connections, parameter group issues.

## Prevention / best practices
- Query optimization, read replicas, connection pooling, monitoring.

## Sample spoken answer
"Check CloudWatch for CPU metrics. Use Performance Insights for slow queries. Run EXPLAIN on queries. Check connections. Optimize indexes and queries."

## AWS: S3 Access Denied After Policy Change

## Scenario
Application can't access S3 bucket after IAM policy update.

## Interview question
"How do you troubleshoot S3 access denied errors?"

## What interviewer evaluates
IAM permissions, S3 policies.

## Troubleshooting approach
- Check IAM user/role policies
- Bucket policies and ACLs
- VPC endpoints if applicable
- KMS encryption keys
- CloudTrail for access attempts

## Commands / tools
```
aws s3 ls s3://bucket
aws iam get-user-policy
aws s3api get-bucket-policy
aws cloudtrail lookup-events --lookup-attributes Key=EventName,Value=GetObject
```

## Root cause possibilities
- Policy changes, incorrect principals, encryption key issues, VPC restrictions.

## Prevention / best practices
- Least privilege, policy testing, version control for policies.

## Sample spoken answer
"Check IAM policies attached to the role. Verify bucket policy allows the principal. Check CloudTrail for denied requests. Ensure KMS permissions if encrypted."

# DevOps Scenarios

## DevOps: CI/CD Deployment Succeeded but App Broken

## Scenario
Jenkins pipeline green, but production app returning errors.

## Interview question
"How do you handle successful deployments that break the app?"

## What interviewer evaluates
Deployment verification, rollback procedures.

## Troubleshooting approach
- Check application logs
- Verify configuration changes
- Database migrations
- Environment differences
- Health checks post-deployment

## Commands / tools
```
kubectl logs <pod>
docker logs <container>
git log --oneline -10
curl -I http://app/health
```

## Root cause possibilities
- Config drift, missing dependencies, database issues, environment variables.

## Prevention / best practices
- Automated testing, canary deployments, feature flags, monitoring.

## Sample spoken answer
"Check app logs for errors. Verify config files. Test health endpoints. Rollback if needed. Add integration tests."

## DevOps: Secrets Worked Yesterday, Fail Today

## Scenario
Application authentication fails, secrets were working fine yesterday.

## Interview question
"How do you troubleshoot authentication failures with secrets?"

## What interviewer evaluates
Secret management, rotation policies.

## Troubleshooting approach
- Check secret expiration
- Rotation schedules
- Access logs
- Key management
- Application code changes

## Commands / tools
```
aws secretsmanager describe-secret
kubectl get secrets
vault status
openssl x509 -in cert.pem -text
```

## Root cause possibilities
- Secret expiration, rotation failures, code changes, permission issues.

## Prevention / best practices
- Automated rotation, monitoring expiration, secure storage.

## Sample spoken answer
"Check if secrets expired. Verify rotation worked. Look at access logs. Check for code changes affecting secret usage."

## DevOps: Monitoring Alerts Fire but No Real Issue

## Scenario
Alerts for high CPU, but application performing normally.

## Interview question
"How do you handle false positive monitoring alerts?"

## What interviewer evaluates
Alert tuning, threshold setting.

## Troubleshooting approach
- Review alert thresholds
- Check monitoring configuration
- Historical data comparison
- False positives from spikes
- Adjust alerting rules

## Commands / tools
```
prometheus query: rate(cpu_usage[5m])
grafana dashboard
alertmanager status
```

## Root cause possibilities
- Too sensitive thresholds, temporary spikes, configuration errors.

## Prevention / best practices
- Tune thresholds based on baselines, use multiple metrics, alert fatigue reduction.

## Sample spoken answer
"Check alert rules and thresholds. Compare with historical data. Adjust sensitivity. Use composite alerts."

## DevOps: Docker Image Pull Fails in Production

## Scenario
CI builds image successfully, but production can't pull it.

## Interview question
"How do you troubleshoot Docker image pull failures?"

## What interviewer evaluates
Registry access, networking.

## Troubleshooting approach
- Check registry credentials
- Network connectivity to registry
- Image existence and tags
- Disk space on nodes
- Registry policies

## Commands / tools
```
docker pull <image>
docker login <registry>
curl -I https://registry/image/manifest
kubectl describe pod <pod>
```

## Root cause possibilities
- Auth issues, network blocks, image not pushed, registry down.

## Prevention / best practices
- Automated builds, registry monitoring, secure credentials.

## Sample spoken answer
"Verify image exists in registry. Check credentials. Test network connectivity. Ensure image was pushed after build."

## DevOps: Git Branch Protection Bypass

## Scenario
Protected branch allows direct pushes, bypassing reviews.

## Interview question
"How do you enforce Git branch protection?"

## What interviewer evaluates
Git workflow, security practices.

## Troubleshooting approach
- Check branch protection rules
- User permissions
- Force push attempts
- Webhook configurations

## Commands / tools
```
git branch -r
git log --oneline
gh api repos/owner/repo/branches/main/protection
```

## Root cause possibilities
- Rules not applied, admin overrides, misconfigurations.

## Prevention / best practices
- Strict branch protection, code reviews, automated checks.

## Sample spoken answer
"Check branch protection settings. Verify user roles. Audit push history. Enforce rules and educate team."

# Kubernetes Scenarios

## Kubernetes: Pods Running but Service Not Reachable

## Scenario
Pods are running and healthy, but service returns connection refused.

## Interview question
"How do you troubleshoot unreachable Kubernetes services?"

## What interviewer evaluates
Networking, service configuration.

## Troubleshooting approach
- Check service endpoints
- Pod IP accessibility
- Service selector matching
- Network policies
- DNS resolution

## Commands / tools
```
kubectl get svc
kubectl get endpoints
kubectl exec -it <pod> -- curl <service-ip>
kubectl describe svc <service>
nslookup <service-name>
```

## Root cause possibilities
- Selector mismatch, network policies, DNS issues, port mismatches.

## Prevention / best practices
- Verify selectors, monitor endpoints, use network debugging tools.

## Sample spoken answer
"Check if service has endpoints with kubectl get endpoints. Verify selectors match pod labels. Test pod-to-pod communication."

## Kubernetes: Nodes Not Ready Suddenly

## Scenario
Multiple nodes become NotReady status without warning.

## Interview question
"How do you troubleshoot nodes becoming NotReady?"

## What interviewer evaluates
Cluster health, node issues.

## Troubleshooting approach
- Check node status and conditions
- Resource usage (CPU, memory, disk)
- Kubelet logs
- Network connectivity
- Hardware failures

## Commands / tools
```
kubectl get nodes
kubectl describe node <node>
journalctl -u kubelet
docker ps | grep kube
```

## Root cause possibilities
- Resource exhaustion, network issues, kubelet crashes, disk full.

## Prevention / best practices
- Monitor node metrics, auto-healing, resource limits.

## Sample spoken answer
"Describe the node to see conditions. Check kubelet logs. Verify resources. If disk full, clean up. Restart kubelet if needed."

## Kubernetes: HPA Not Scaling Even with High CPU

## Scenario
Pods at 90% CPU, but HPA not triggering scale out.

## Interview question
"How do you troubleshoot HPA not scaling?"

## What interviewer evaluates
Autoscaling configuration.

## Troubleshooting approach
- Check HPA status and metrics
- Metrics server health
- Target utilization settings
- Pod resource requests/limits
- Cooldown periods

## Commands / tools
```
kubectl get hpa
kubectl describe hpa <hpa>
kubectl top pods
kubectl get apiservices | grep metrics
```

## Root cause possibilities
- Metrics server down, wrong targets, resource limits not set, cooldown active.

## Prevention / best practices
- Ensure metrics server, set proper requests, monitor HPA events.

## Sample spoken answer
"Check HPA with kubectl get hpa. Verify metrics server is running. Ensure pods have resource requests. Check target CPU percentage."

## Kubernetes: Persistent Volume Claims Pending

## Scenario
PVCs stuck in Pending state, pods can't start.

## Interview question
"How do you troubleshoot pending PVCs?"

## What interviewer evaluates
Storage provisioning.

## Troubleshooting approach
- Check PVC status and events
- Storage class configuration
- Available storage capacity
- Provisioner logs
- Node selectors

## Commands / tools
```
kubectl get pvc
kubectl describe pvc <pvc>
kubectl get sc
kubectl logs <provisioner-pod>
```

## Root cause possibilities
- No storage class, insufficient capacity, provisioner issues, access modes.

## Prevention / best practices
- Monitor storage usage, multiple storage classes, quotas.

## Sample spoken answer
"Describe PVC to see events. Check storage class exists and has provisioner. Verify cluster has available storage."

## Kubernetes: Ingress Not Routing Traffic

## Scenario
Ingress created, but requests not reaching services.

## Interview question
"How do you troubleshoot Ingress routing issues?"

## What interviewer evaluates
Ingress controller configuration.

## Troubleshooting approach
- Check ingress status and rules
- Controller pod logs
- Service backend health
- Annotations and TLS
- External access

## Commands / tools
```
kubectl get ingress
kubectl describe ingress <ingress>
kubectl logs <ingress-controller>
curl -k https://<ingress-host>
```

## Root cause possibilities
- Controller not running, rules misconfigured, TLS issues, service not ready.

## Prevention / best practices
- Test ingress rules, monitor controller health, use cert-manager for TLS.

## Sample spoken answer
"Check ingress with kubectl describe. Verify controller is running. Test service directly. Check annotations for TLS."

# Docker Scenarios

## Docker: Container Keeps Restarting in Production

## Scenario
Docker container restarts every few minutes in production.

## Interview question
"How do you troubleshoot restarting Docker containers?"

## What interviewer evaluates
Container lifecycle, health checks.

## Troubleshooting approach
- Check container logs
- Health check configuration
- Resource limits
- Exit codes
- Application errors

## Commands / tools
```
docker ps -a
docker logs <container>
docker inspect <container>
docker stats <container>
```

## Root cause possibilities
- Health check failing, OOM killed, application crashes, dependency issues.

## Prevention / best practices
- Proper health checks, resource allocation, logging, monitoring.

## Sample spoken answer
"Check docker logs for errors. Inspect container for restart policy and exit code. Verify health checks. Check resource usage."

## Docker: Image Build Fails Intermittently

## Scenario
Docker builds succeed locally but fail randomly in CI.

## Interview question
"How do you troubleshoot intermittent Docker build failures?"

## What interviewer evaluates
Build reproducibility, caching.

## Troubleshooting approach
- Check build logs for errors
- Cache layers issues
- Base image changes
- Network timeouts
- Disk space

## Commands / tools
```
docker build --no-cache .
docker history <image>
docker system df
```

## Root cause possibilities
- Network issues, cache invalidation, base image updates, disk full.

## Prevention / best practices
- Use specific image tags, multi-stage builds, build caching.

## Sample spoken answer
"Rebuild without cache. Check for network errors. Pin base image versions. Ensure sufficient disk space."

## Docker: Container Can't Access Host Network

## Scenario
Container can't reach services on host network.

## Interview question
"How do you troubleshoot Docker network connectivity?"

## What interviewer evaluates
Docker networking.

## Troubleshooting approach
- Check network mode
- DNS resolution
- Firewall rules
- Bridge network configuration
- Host port mapping

## Commands / tools
```
docker network ls
docker inspect <container> | grep Network
docker exec <container> ping host.docker.internal
iptables -L
```

## Root cause possibilities
- Wrong network mode, DNS issues, firewall blocking, port conflicts.

## Prevention / best practices
- Use appropriate network modes, configure DNS, manage firewall rules.

## Sample spoken answer
"Check container's network mode. Test connectivity with ping. Verify firewall allows traffic. Check port mappings."

## Docker: Volume Data Lost After Container Restart

## Scenario
Data in Docker volume disappears after container restart.

## Interview question
"How do you troubleshoot Docker volume data loss?"

## What interviewer evaluates
Volume management.

## Troubleshooting approach
- Check volume mounting
- Volume driver
- Container restart policy
- Data persistence
- Host directory permissions

## Commands / tools
```
docker volume ls
docker inspect <volume>
ls -la /var/lib/docker/volumes/
docker run --rm -v <volume>:/data alpine ls /data
```

## Root cause possibilities
- Volume not mounted, wrong path, permissions, ephemeral containers.

## Prevention / best practices
- Named volumes, backup strategies, proper mounting.

## Sample spoken answer
"Verify volume is mounted correctly. Check volume exists and has data. Test with temporary container."

## Docker: Multi-Container App Communication Fails

## Scenario
Containers in docker-compose can't communicate.

## Interview question
"How do you troubleshoot Docker Compose networking?"

## What interviewer evaluates
Compose configuration.

## Troubleshooting approach
- Check compose file networks
- Service names and links
- Environment variables
- Port conflicts
- Network isolation

## Commands / tools
```
docker-compose ps
docker network ls
docker exec <container> ping <service>
docker-compose logs
```

## Root cause possibilities
- Network not defined, service names wrong, ports conflicting.

## Prevention / best practices
- Define networks explicitly, use service names, test locally.

## Sample spoken answer
"Check docker-compose.yml for network config. Verify service names. Test inter-container ping."

# Terraform Scenarios

## Terraform: Plan Shows Changes But Shouldn't

## Scenario
Terraform plan shows unexpected resource changes.

## Interview question
"How do you troubleshoot unexpected Terraform plan changes?"

## What interviewer evaluates
State management, configuration drift.

## Troubleshooting approach
- Check state file
- Compare with actual resources
- Import resources if needed
- Check provider versions
- Lifecycle rules

## Commands / tools
```
terraform plan
terraform state list
terraform show
aws ec2 describe-instances
```

## Root cause possibilities
- State drift, manual changes, provider updates, lifecycle ignore_changes.

## Prevention / best practices
- Avoid manual changes, use remote state, version control.

## Sample spoken answer
"Check terraform state vs actual resources. Import drifted resources. Use lifecycle blocks to ignore changes."

## Terraform: Apply Fails with Dependency Error

## Scenario
Terraform apply fails due to resource dependency issues.

## Interview question
"How do you resolve Terraform dependency conflicts?"

## What interviewer evaluates
Resource dependencies.

## Troubleshooting approach
- Check resource dependencies
- Use depends_on
- Refactor module structure
- Data sources vs resources
- Implicit dependencies

## Commands / tools
```
terraform graph
terraform validate
terraform plan -target=<resource>
```

## Root cause possibilities
- Circular dependencies, missing depends_on, wrong order.

## Prevention / best practices
- Explicit dependencies, modular design, graph visualization.

## Sample spoken answer
"Use terraform graph to visualize dependencies. Add depends_on if needed. Refactor to avoid cycles."

## Terraform: State Lock Prevents Operations

## Scenario
Terraform operations blocked by state lock.

## Interview question
"How do you handle Terraform state locks?"

## What interviewer evaluates
State management, concurrency.

## Troubleshooting approach
- Check who has the lock
- Force unlock if stale
- Backend configuration
- Concurrent runs

## Commands / tools
```
terraform force-unlock <lock-id>
terraform state pull
dynamodb scan --table-name <table>
```

## Root cause possibilities
- Stale locks, interrupted runs, backend issues.

## Prevention / best practices
- Short-lived locks, monitor operations, backup state.

## Sample spoken answer
"Check who holds the lock. If stale, force unlock. Ensure backend is accessible."

## Terraform: Provider Authentication Fails

## Scenario
Terraform can't authenticate with cloud provider.

## Interview question
"How do you troubleshoot Terraform provider auth issues?"

## What interviewer evaluates
Credentials management.

## Troubleshooting approach
- Check credentials configuration
- Environment variables
- Profile settings
- Token expiration
- Permissions

## Commands / tools
```
aws sts get-caller-identity
terraform init
export AWS_PROFILE=<profile>
```

## Root cause possibilities
- Expired tokens, wrong credentials, profile issues.

## Prevention / best practices
- Use IAM roles, rotate credentials, secure storage.

## Sample spoken answer
"Verify credentials with provider CLI. Check environment variables. Ensure permissions are correct."

## Terraform: Module Output Not Available

## Scenario
Module outputs not accessible in parent configuration.

## Interview question
"How do you troubleshoot missing Terraform module outputs?"

## What interviewer evaluates
Module design.

## Troubleshooting approach
- Check output definitions
- Module source and version
- Variable passing
- State refresh

## Commands / tools
```
terraform output
terraform show
cat module/outputs.tf
```

## Root cause possibilities
- Outputs not defined, wrong syntax, module not applied.

## Prevention / best practices
- Define outputs clearly, test modules, documentation.

## Sample spoken answer
"Check module's outputs.tf. Ensure module is applied. Use terraform output to list available outputs."

# Git Scenarios

## Git: Merge Conflict Resolution Fails

## Scenario
Git merge results in conflicts that can't be resolved properly.

## Interview question
"How do you handle complex Git merge conflicts?"

## What interviewer evaluates
Version control skills.

## Troubleshooting approach
- Identify conflicting files
- Understand changes
- Use merge tools
- Abort and retry
- Manual resolution

## Commands / tools
```
git status
git diff
git mergetool
git merge --abort
```

## Root cause possibilities
- Simultaneous changes, different strategies.

## Prevention / best practices
- Frequent pulls, clear commit messages, code reviews.

## Sample spoken answer
"Check git status for conflicts. Use git diff to understand changes. Resolve manually or with mergetool. Test after merge."

## Git: Lost Commits After Rebase

## Scenario
Commits disappear after interactive rebase.

## Interview question
"How do you recover lost commits in Git?"

## What interviewer evaluates
Git recovery.

## Troubleshooting approach
- Check reflog
- Recover from backup
- Recreate commits
- Use git fsck

## Commands / tools
```
git reflog
git fsck --lost-found
git cherry-pick <commit>
```

## Root cause possibilities
- Rebase mistakes, force pushes.

## Prevention / best practices
- Backup branches, careful rebasing, push before rebase.

## Sample spoken answer
"Use git reflog to find lost commits. Cherry-pick them back. Avoid force push on shared branches."

## Git: Repository Corruption

## Scenario
Git repository becomes corrupted, operations fail.

## Interview question
"How do you repair a corrupted Git repository?"

## What interviewer evaluates
Repository maintenance.

## Troubleshooting approach
- Run git fsck
- Check objects
- Clone fresh copy
- Restore from backup

## Commands / tools
```
git fsck
git gc
git clone <remote> <new-dir>
```

## Root cause possibilities
- Disk issues, interrupted operations.

## Prevention / best practices
- Regular backups, monitor disk health.

## Sample spoken answer
"Run git fsck to identify corruption. Try git gc to clean up. If severe, clone from remote backup."

## Git: Branch Diverged After Push

## Scenario
Local and remote branches have diverged.

## Interview question
"How do you handle diverged Git branches?"

## What interviewer evaluates
Branch management.

## Troubleshooting approach
- Fetch latest changes
- Merge or rebase
- Force push if appropriate
- Coordinate with team

## Commands / tools
```
git fetch
git pull --rebase
git push --force-with-lease
```

## Root cause possibilities
- Concurrent pushes, different workflows.

## Prevention / best practices
- Communicate changes, use pull requests.

## Sample spoken answer
"Fetch remote changes. Rebase local commits. Push with force-with-lease to avoid overwriting."

## Git: Large Files Causing Performance Issues

## Scenario
Git operations slow due to large files in history.

## Interview question
"How do you handle large files in Git repositories?"

## What interviewer evaluates
Repository optimization.

## Troubleshooting approach
- Use Git LFS
- Remove large files from history
- Shallow clones
- Archive old history

## Commands / tools
```
git lfs track "*.psd"
git filter-branch --tree-filter 'rm -f large-file' HEAD
git gc --aggressive
```

## Root cause possibilities
- Committed large binaries.

## Prevention / best practices
- Use LFS for large files, .gitignore binaries.

## Sample spoken answer
"Move large files to Git LFS. Use filter-branch to remove from history. Run git gc to optimize."

# Jenkins Scenarios

## Jenkins: Pipeline Fails Randomly

## Scenario
Jenkins pipeline succeeds sometimes, fails others without code changes.

## Interview question
"How do you troubleshoot flaky Jenkins pipelines?"

## What interviewer evaluates
CI/CD reliability.

## Troubleshooting approach
- Check agent availability
- Resource constraints
- Network issues
- Plugin conflicts
- Environment differences

## Commands / tools
```
jenkins logs
docker ps
kubectl get pods
```

## Root cause possibilities
- Agent overload, network timeouts, plugin bugs.

## Prevention / best practices
- Stable agents, retry mechanisms, monitoring.

## Sample spoken answer
"Check Jenkins logs for errors. Verify agent health. Add retry logic. Monitor resource usage."

## Jenkins: Build Queue Backed Up

## Scenario
Jenkins build queue has hundreds of pending jobs.

## Interview question
"How do you manage Jenkins build queue congestion?"

## What interviewer evaluates
CI/CD scaling.

## Troubleshooting approach
- Check agent capacity
- Optimize build times
- Parallel execution
- Queue management
- Resource allocation

## Commands / tools
```
jenkins queue
jenkins nodes
```

## Root cause possibilities
- Insufficient agents, long builds, dependencies.

## Prevention / best practices
- Auto-scaling agents, build optimization, parallel stages.

## Sample spoken answer
"Increase agent capacity. Optimize slow builds. Use parallel execution. Set queue priorities."

## Jenkins: Plugin Compatibility Issues

## Scenario
Jenkins upgrade breaks due to plugin incompatibilities.

## Interview question
"How do you handle Jenkins plugin conflicts?"

## What interviewer evaluates
Plugin management.

## Troubleshooting approach
- Check plugin versions
- Update compatibility matrix
- Test upgrades
- Rollback procedures

## Commands / tools
```
jenkins plugin list
jenkins restart
```

## Root cause possibilities
- Outdated plugins, version mismatches.

## Prevention / best practices
- Regular updates, compatibility checks, staging environment.

## Sample spoken answer
"Check plugin compatibility with Jenkins version. Update plugins gradually. Test in staging."

## Jenkins: Security Vulnerabilities

## Scenario
Jenkins reports security vulnerabilities in plugins.

## Interview question
"How do you address Jenkins security vulnerabilities?"

## What interviewer evaluates
Security practices.

## Troubleshooting approach
- Update plugins
- Review permissions
- Audit configurations
- Isolate Jenkins

## Commands / tools
```
jenkins security scan
jenkins plugin update
```

## Root cause possibilities
- Outdated software, misconfigurations.

## Prevention / best practices
- Regular updates, least privilege, monitoring.

## Sample spoken answer
"Update vulnerable plugins. Review user permissions. Enable security features."

## Jenkins: Distributed Builds Fail

## Scenario
Jobs fail on remote agents but succeed on master.

## Interview question
"How do you troubleshoot distributed Jenkins builds?"

## What interviewer evaluates
Agent management.

## Troubleshooting approach
- Check agent connectivity
- Environment differences
- Tool versions
- Network issues
- Workspace problems

## Commands / tools
```
ssh agent
jenkins agent logs
```

## Root cause possibilities
- Network issues, missing tools, path differences.

## Prevention / best practices
- Standardize agent environments, monitoring.

## Sample spoken answer
"Check agent logs. Verify tool installations. Test connectivity. Standardize environments."

# Monitoring Scenarios

## Monitoring: Alerts Fire But No Real Issue

## Scenario
Monitoring alerts trigger but application is fine.

## Interview question
"How do you reduce monitoring false positives?"

## What interviewer evaluates
Alert tuning.

## Troubleshooting approach
- Review thresholds
- Check alert conditions
- Historical analysis
- Adjust sensitivity
- Multiple signals

## Commands / tools
```
prometheus query
grafana alerts
```

## Root cause possibilities
- Over-sensitive thresholds, temporary spikes.

## Prevention / best practices
- Baseline thresholds, composite alerts.

## Sample spoken answer
"Analyze alert patterns. Adjust thresholds based on normal ranges. Use multiple metrics."

## Monitoring: Incident Happened But No Logs

## Scenario
Application outage occurred but no useful logs captured.

## Interview question
"How do you improve logging for incident response?"

## What interviewer evaluates
Logging strategies.

## Troubleshooting approach
- Review log levels
- Check log shipping
- Storage capacity
- Structured logging
- Retention policies

## Commands / tools
```
grep "ERROR" logs
logstash config
```

## Root cause possibilities
- Insufficient logging, log loss, retention too short.

## Prevention / best practices
- Comprehensive logging, centralized storage, analysis tools.

## Sample spoken answer
"Increase log verbosity. Ensure log shipping works. Implement structured logging."

## Monitoring: Metrics Missing During Outage

## Scenario
Key metrics unavailable during critical incident.

## Interview question
"How do you ensure monitoring reliability?"

## What interviewer evaluates
Monitoring architecture.

## Troubleshooting approach
- Check collector health
- Network connectivity
- Configuration drift
- Redundancy
- Backup systems

## Commands / tools
```
prometheus targets
telegraf status
```

## Root cause possibilities
- Collector failure, network issues, config changes.

## Prevention / best practices
- High availability, monitoring the monitoring.

## Sample spoken answer
"Check monitoring system health. Implement redundancy. Monitor collectors themselves."

## Monitoring: Alert Fatigue

## Scenario
Too many alerts, team ignoring important ones.

## Interview question
"How do you manage alert fatigue?"

## What interviewer evaluates
Alert management.

## Troubleshooting approach
- Prioritize alerts
- Group notifications
- Auto-resolve
- On-call rotation
- Alert reviews

## Commands / tools
```
alertmanager config
pagerduty incidents
```

## Root cause possibilities
- Too many low-priority alerts, poor routing.

## Prevention / best practices
- Alert classification, maintenance windows, automation.

## Sample spoken answer
"Classify alerts by severity. Group similar alerts. Implement auto-resolution for known issues."

## Monitoring: Performance Degradation Not Detected

## Scenario
Application slowed down but no alerts triggered.

## Interview question
"How do you improve performance monitoring?"

## What interviewer evaluates
Performance metrics.

## Troubleshooting approach
- Add latency metrics
- Error rate monitoring
- Throughput tracking
- User experience metrics
- Anomaly detection

## Commands / tools
```
prometheus query: histogram_quantile(0.95, rate(http_request_duration_seconds[5m]))
apm traces
```

## Root cause possibilities
- Missing metrics, wrong thresholds.

## Prevention / best practices
- Comprehensive metrics, synthetic monitoring.

## Sample spoken answer
"Add latency percentiles. Monitor error rates. Set up anomaly detection."