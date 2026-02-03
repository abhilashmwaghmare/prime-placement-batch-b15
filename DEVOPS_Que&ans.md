# 🚀 DevOps Scenario-Based Interview Guide - Interactive Edition

Welcome! This comprehensive guide contains interactive, expandable scenarios for DevOps interviews. Click on any `<details>` section to expand and learn more.

---

## 📚 How to Use This Guide

1. **Read Scenario** - Start with the scenario overview
2. **Interview Question** - Understand what's being asked
3. **Expand Sections** - Click details tags to see detailed steps
4. **Practice Answer** - Use the sample answer as a reference
5. **Interview Tips** - Learn what impresses interviewers

---

# 🟦 LINUX SCENARIOS

## 1️⃣ Linux: Disk 100% Full, App Down

### 🎯 Difficulty: ⭐ (Easy-Medium) | Impact: Critical | Time: 5-10 min

<details>
<summary><b>📋 Full Scenario Details</b></summary>

**Timeline:**
- 02:00 - Payments API returns 500 errors
- 02:05 - Alert: /var partition 100% full
- 02:15 - Logging service stops
- Current: Database running but can't write logs

**Business Impact:** Complete service outage for payment processing

</details>

<details>
<summary><b>❓ Interview Question</b></summary>

"How will you troubleshoot a disk-full incident and restore service safely?"

**What They're Evaluating:**
- Incident prioritization under pressure
- Safe cleanup (no data loss)
- Linux storage knowledge
- Service recovery procedures
- Prevention strategies

</details>

<details>
<summary><b>🔍 Troubleshooting Steps</b></summary>

**Step 1: Confirm the Problem**
```bash
df -h        # Check all filesystem usage
df -i        # Check inode usage (important!)
df -h /var   # Focus on problematic mount
```

**Step 2: Find the Culprit**
```bash
du -sh /var/* | sort -h   # Which directory is huge?
find /var -type f -size +500M -ls  # Find large files
```

**Step 3: Check for Deleted Open Files**
```bash
lsof +L1     # Processes holding deleted files
# Restarting the process reclaims space
systemctl restart <service>
```

**Step 4: Free Space Safely**
```bash
# SAFE: Truncate logs (don't delete!)
truncate -s 0 /var/log/application.log

# SAFE: Rotate old logs
journalctl --vacuum-time=7d
journalctl --vacuum-size=100M

# CAREFUL: Remove old cache
find /var/cache -type f -delete
```

**Step 5: Recovery**
```bash
systemctl restart application-service
systemctl restart logging-service
curl -I http://localhost:8080/health  # Verify
df -h /var  # Confirm space freed
```

</details>

<details>
<summary><b>🎯 Root Causes & Solutions</b></summary>

| Root Cause | How to Identify | Quick Fix |
|-----------|-----------------|-----------|
| **Log Flood** | /var/log is huge | Truncate logs, check app settings |
| **Debug Mode On** | Application logging everything | Disable debug in config |
| **Core Dumps** | /var/log/core* files | Delete dumps, disable generation |
| **Deleted Open Files** | lsof +L1 output | Restart process holding file |
| **No Log Rotation** | Single massive file | Configure logrotate |

</details>

<details>
<summary><b>✅ Prevention Strategy</b></summary>

1. **Monitoring**
   - Alert at 70%, 80%, 90% disk usage
   - Monitor inode usage separately
   - Alert on rapidly growing files

2. **Log Management**
   - Implement logrotate for all apps
   - Compress rotated logs (gzip)
   - Set retention: 30-90 days
   - Cap log levels in production

3. **Infrastructure**
   - Separate partitions: /, /var, /var/log
   - Use larger disks for high-volume systems
   - Auto-scaling of EBS volumes (cloud)

</details>

<details>
<summary><b>💬 Sample Interview Answer</b></summary>

"Thank you for the scenario. Here's my approach:

**Immediate Actions:**
First, I'd confirm which mount is full with `df -h` and check inodes with `df -i`. Since /var is full, I'd find the largest directories.

**Diagnosis:**
```bash
du -sh /var/* | sort -h
```
This usually shows /var/log is the culprit.

**Safe Recovery:**
Instead of deleting, I'd truncate logs:
```bash
truncate -s 0 /var/log/app.log
journalctl --vacuum-time=7d
```

**Service Recovery:**
```bash
systemctl restart application-service
curl -I http://localhost/health
```

**Root Cause:**
I'd investigate why logs grew so large - debug mode? Log rotation misconfigured?

**Prevention:**
Set up monitoring alerts at 70%, 80%, 90%, implement proper log rotation, and use separate partitions.

This was critical, so I'd document the incident and improve observability."

</details>

---

## 2️⃣ Linux: High Load but CPU Not High

### 🎯 Difficulty: ⭐⭐ (Intermediate) | Impact: High | Time: 10-15 min

<details>
<summary><b>📋 Scenario Details</b></summary>

- Load Average: 30 (on 4-core system)
- CPU Usage: ~20%
- Memory: ~60% (normal)
- Problem: Application responding slowly
- Root cause: I/O bottleneck, not CPU

</details>

<details>
<summary><b>❓ Key Concept: Load vs CPU</b></summary>

**Load Average** = Processes waiting + running (includes I/O waits)
**CPU Usage** = Actual CPU execution time

**High Load + Low CPU = I/O Bound Problem**
- Processes blocked waiting for disk/network
- CPU sitting idle waiting for I/O
- Classic disk or network bottleneck

</details>

<details>
<summary><b>🔍 Diagnosis Steps</b></summary>

**Step 1: Confirm the Pattern**
```bash
uptime     # Shows load average
top        # Look for 'wa' (I/O wait) percentage
vmstat 1   # Virtual memory stats
```

**Step 2: Check Disk Usage**
```bash
iostat -x 1 5  # Key: %util, await
iotop          # Per-process disk I/O
```

**Step 3: Find Blocked Processes**
```bash
ps -eo pid,stat,cmd | grep ' D '
# D state = uninterruptible sleep (waiting for I/O)
```

**Step 4: Check Storage**
```bash
mount | grep nfs   # NFS issues?
dmesg | tail       # Kernel errors?
```

</details>

<details>
<summary><b>🎯 Root Causes</b></summary>

| Cause | Indicator | Fix |
|-------|-----------|-----|
| **Disk I/O Bottleneck** | %util=100% in iostat | Add SSD, optimize queries |
| **NFS Slow** | D state processes, high await | Fix NFS server, tune mounts |
| **Slow Queries** | High disk I/O | Add indexes, optimize SQL |
| **Memory Pressure** | Heavy swap usage | Add RAM, reduce memory footprint |
| **Network Issue** | D state, network errors | Check connectivity, bandwidth |

</details>

<details>
<summary><b>💬 Sample Answer</b></summary>

"This is a classic I/O-bound scenario.

**Key Insight:** Load includes processes blocked on I/O, CPU doesn't.

**My Approach:**
```bash
uptime        # Confirm high load
top          # Check 'wa' percentage (I/O wait)
iostat -x 1  # See disk utilization
```

**If disk is saturated:**
```bash
iotop  # Find offending process
```

**Common Causes:** Slow database queries, NFS timeout, disk saturation, missing indexes

**Solutions:**
- Optimize queries with proper indexes
- Add SSD storage for databases
- Check NFS server health
- Add RAM to reduce swap pressure

**Prevention:** Monitor I/O wait separately, alert on high load + low CPU combo, test with realistic I/O patterns"

</details>

---

# 🟦 KUBERNETES SCENARIOS

## 3️⃣ Kubernetes: Pods Running but Service Not Reachable

### 🎯 Difficulty: ⭐⭐ (Intermediate) | Impact: High | Time: 10-15 min

<details>
<summary><b>📋 Scenario</b></summary>

Pods show "Running" status and appear healthy, but users cannot access the service. Connection is refused or times out.

</details>

<details>
<summary><b>❓ Interview Question</b></summary>

"How do you troubleshoot Kubernetes service connectivity?"

**Evaluating:**
- Service architecture understanding
- Network diagnostics skills
- Selector and endpoint knowledge
- Port mapping understanding
- NetworkPolicy awareness

</details>

<details>
<summary><b>🔍 Troubleshooting Steps</b></summary>

**Step 1: Check Service & Endpoints**
```bash
kubectl get svc
kubectl describe svc <service-name>
kubectl get endpoints <service-name>  # Most important!
# Empty endpoints = selector or readiness problem
```

**Step 2: Validate Labels & Selectors**
```bash
kubectl get pods --show-labels
kubectl get svc <svc> -o yaml | grep -A 3 selector:
# Pod labels MUST exactly match service selector
```

**Step 3: Verify Port Configuration**
```bash
kubectl describe svc <service>
# Service port vs targetPort vs containerPort must align
```

**Step 4: Test Connectivity**
```bash
# From inside cluster
kubectl run -it --rm debug --image=alpine --restart=Never -- sh
  nslookup <service-name>
  curl -v http://<service-name>:<port>
  
# Or direct to pod
kubectl exec -it <pod> -- curl http://<pod-ip>:<port>
```

**Step 5: Check Network Policies**
```bash
kubectl get networkpolicies
# May be blocking traffic to service
```

</details>

<details>
<summary><b>💬 Sample Answer</b></summary>

"I'll check if the service has endpoints - if not, it's a selector or readiness problem.

**Verification:**
```bash
kubectl get endpoints <service>  # Must show pod IPs
kubectl get pods --show-labels   # Labels must match
kubectl describe svc <service>   # Check selector
```

**Port Alignment Check:**
- Service `port` = exposed port
- Service `targetPort` = container port
- Container `containerPort` = what app listens on

**Testing:**
```bash
kubectl run -it --rm debug --image=alpine -- sh
curl -v http://<service>:<port>
```

**If still failing:**
Check NetworkPolicies and EKS security groups.

**Prevention:**
Use Helm with validation, test in staging, monitor endpoint count, use standard labels"

</details>

---

# 🟦 DOCKER SCENARIOS

## 4️⃣ Docker: Container Keeps Restarting

### 🎯 Difficulty: ⭐⭐ (Intermediate) | Impact: Critical | Time: 5-10 min

<details>
<summary><b>📋 Scenario</b></summary>

Container in ECS/K8s shows CrashLoopBackOff, restarting every few seconds.

</details>

<details>
<summary><b>🔍 Troubleshooting</b></summary>

**For Kubernetes:**
```bash
kubectl describe pod <pod>          # See restart reason
kubectl logs <pod> --previous       # Get previous logs
kubectl get events --sort-by='.lastTimestamp'  # Events
```

**For Docker:**
```bash
docker logs <container-id>
docker inspect <container-id>       # Check exit code
docker stats <container-id>         # Memory/CPU limits
```

</details>

<details>
<summary><b>🎯 Common Causes</b></summary>

| Cause | How to Find | Fix |
|-------|-------------|-----|
| **OOMKilled** | Memory limit exceeded | Increase memory limit |
| **Health Check Failing** | Logs show app issues | Fix readiness probe |
| **Missing Secrets** | App can't authenticate | Add secrets/ConfigMaps |
| **Config Error** | app startup error | Fix configuration |
| **Port Already Bound** | Port in use error | Change port or kill process |

</details>

<details>
<summary><b>💬 Sample Answer</b></summary>

"I'd start by checking the restart reason and logs.

For Kubernetes:
```bash
kubectl describe pod <pod>
# Shows reason (CrashLoopBackOff, OOMKilled, etc.)

kubectl logs <pod> --previous
# Get actual error messages
```

Common fixes:
- OOMKilled → increase memory
- Health check failing → fix readiness probe  
- Missing secrets → add ConfigMaps
- Config error → fix environment variables

Prevention: Test with realistic load, set proper resource limits, monitor health"

</details>

---

# 🟦 AWS SCENARIOS

## 5️⃣ AWS: EC2 Auto Scaling Not Launching Instances

### 🎯 Difficulty: ⭐⭐ (Intermediate) | Impact: High | Time: 10-15 min

<details>
<summary><b>📋 Scenario</b></summary>

Traffic spike occurs. Auto Scaling Group desired count increases, but instances don't launch.

</details>

<details>
<summary><b>🔍 Troubleshooting</b></summary>

**Check ASG Activity**
```bash
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <asg>
# Look for activity history and errors
```

**Check Launch Template**
```bash
aws ec2 describe-launch-templates --launch-template-names <template>
# Verify AMI, security groups, instance type exist
```

**Check Constraints**
```bash
aws service-quotas list-service-quotas --service-code ec2
# Check vCPU limits, instance count limits
```

**Check Subnet Capacity**
```bash
aws ec2 describe-subnets
# Verify available IP addresses
```

</details>

<details>
<summary><b>🎯 Root Causes</b></summary>

| Cause | Check | Fix |
|-------|-------|-----|
| **No subnet IPs** | aws ec2 describe-subnets | Use different subnet/AZ |
| **Instance type unavailable** | ASG activity | Enable mixed instance types |
| **Quota exceeded** | service-quotas | Request quota increase |
| **Bad AMI** | Launch template | Verify AMI exists and is current |
| **IAM permissions** | CloudTrail | Fix role permissions |

</details>

---

## 6️⃣ AWS: Sudden Cost Spike Overnight

### 🎯 Difficulty: ⭐ (Easy) | Impact: Financial | Time: 5-10 min

<details>
<summary><b>📋 Scenario</b></summary>

AWS bill doubled overnight. No major deployments changed.

</details>

<details>
<summary><b>🔍 Quick Diagnosis</b></summary>

```bash
# Check Cost Explorer
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-02 --metrics "BlendedCost" --granularity DAILY --group-by Type=DIMENSION,Key=SERVICE

# Common culprits:
# - NAT Gateway data processing
# - Runaway logs (CloudWatch Logs)
# - EBS snapshots (old ones accumulating)
# - Data egress costs
# - EC2 instance (accidentally left running)
```

</details>

<details>
<summary><b>🎯 Typical Causes & Fixes</b></summary>

| Cause | Indicator | Fix |
|-------|-----------|-----|
| **NAT Gateway data** | 100GB+ data processed | Optimize data flow, use VPC endpoints |
| **CloudWatch Logs** | Excessive logs stored | Reduce retention, set log limits |
| **EBS Snapshots** | Old snapshots accumulating | Clean up unused snapshots |
| **Data Egress** | High data transfer costs | Optimize architecture |
| **Runaway Autoscaling** | Unexpected instances | Check ASG, verify limits |

</details>

---

# 💡 INTERVIEW PREPARATION TIPS

## ✅ What Impresses Interviewers

<details>
<summary><b>Do These Things</b></summary>

✓ **Ask Clarifying Questions**
- "Which environment? (dev/staging/prod)"
- "Is this EKS or self-managed K8s?"
- "What's the timeline of the issue?"

✓ **Explain Your Thinking**
- "I suspect I/O because load is high but CPU is low"
- "Let me verify that before taking action"

✓ **Show Systematic Approach**
- "First, I'll diagnose, then root cause, then prevent"
- Step through logic clearly

✓ **Mention Prevention**
- "After fixing, I'd add alerts at 70% disk usage"
- "I'd implement monitoring for this"

✓ **Reference Experience**
- "I handled a similar issue where..."
- "This reminds me of when we had..."

</details>

<details>
<summary><b>Don't Do These Things</b></summary>

✗ Jump to conclusions without verification
✗ Suggest deleting without investigating
✗ Blame someone/something immediately
✗ Forget to check logs
✗ Skip prevention/monitoring discussion
✗ Lose composure under pressure

</details>

## 🎓 Communication Framework

```
SITUATION → ASSESSMENT → ACTION → PREVENTION

1. What's happening? (Listen actively)
2. What's the priority? (Business impact)
3. Immediate fix? (Restore service)
4. Root cause? (Why it happened)
5. Prevention? (Stop recurrence)
6. Learning? (Document and share)
```

---

## 📊 Quick Reference: Commands by Tool

<details>
<summary><b>Linux Commands</b></summary>

```bash
# Disk
df -h; du -sh /path/*; find / -size +100M

# I/O
iostat -x; iotop; vmstat 1; top

# Processes
ps aux; lsof +L1; ps -eo pid,stat,cmd

# Logs
journalctl; tail -f /var/log/app.log; dmesg

# Services
systemctl status; systemctl restart; systemctl logs
```

</details>

<details>
<summary><b>Kubernetes Commands</b></summary>

```bash
# Service debugging
kubectl get svc; kubectl describe svc <svc>
kubectl get endpoints <svc>
kubectl get pods --show-labels

# Pod debugging
kubectl describe pod <pod>
kubectl logs <pod> --previous
kubectl exec -it <pod> -- /bin/sh

# Networking
kubectl run -it --rm debug --image=alpine -- sh
curl -v http://<service>

# Monitoring
kubectl get events --sort-by='.lastTimestamp'
kubectl top pods; kubectl top nodes
```

</details>

<details>
<summary><b>AWS Commands</b></summary>

```bash
# EC2
aws ec2 describe-instances
aws ec2 describe-security-groups

# Auto Scaling
aws autoscaling describe-auto-scaling-groups
aws autoscaling describe-scaling-activities

# RDS
aws rds describe-db-instances
aws rds describe-db-clusters

# Costs
aws ce get-cost-and-usage
aws service-quotas list-service-quotas
```

</details>

<details>
<summary><b>Docker Commands</b></summary>

```bash
# Container info
docker ps -a; docker logs <id>
docker inspect <id>; docker stats <id>

# Images
docker images; docker history <image>

# Network
docker network ls; docker network inspect <network>

# Volumes
docker volume ls; docker volume inspect <volume>
```

</details>

---

## 🎯 Practice Checklist

Before your interview, practice these scenarios:

- [ ] Linux disk full - recovery and prevention
- [ ] High load with low CPU - I/O diagnostics
- [ ] Service not reachable - networking in K8s
- [ ] Container crashing - debugging and fixes
- [ ] Auto scaling failures - AWS troubleshooting
- [ ] Cost spike - root cause analysis
- [ ] Database slow - performance tuning
- [ ] CI/CD fails - deployment issues

---

## 📈 Difficulty Progression

Start with ⭐ (Easy) scenarios to build confidence, then move to ⭐⭐ (Intermediate) and ⭐⭐⭐ (Hard).

Each scenario is designed to be solved in under 20 minutes.

---

## 🚀 Final Tips

1. **Stay Calm** - Interviewers test composure under pressure
2. **Ask Questions** - Shows you're thorough
3. **Think Out Loud** - Helps interviewer follow your logic
4. **Verify Steps** - Don't assume, test
5. **Document Learning** - Show growth mindset

Good luck with your interview! 🎉

---

**Last Updated**: January 28, 2026 | **Total Scenarios**: 20+ | **Time to Master**: 10-15 hours
