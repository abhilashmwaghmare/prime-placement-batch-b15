# 📈 Linux: High Load but CPU Not High

> **Difficulty Level**: ⭐⭐ (Intermediate) | **Time to Resolve**: 15-20 min | **Business Impact**: High (Slow application)

---

## 📋 Scenario

Load average jumped to 30, but CPU usage is only ~20%. The application is responding slowly, but the CPU doesn't seem to be the bottleneck.

<details>
<summary><b>Full Incident Details</b></summary>

- **Load Average**: 30 (4-core system)
- **CPU Usage**: ~20%
- **Memory Usage**: ~60% (normal)
- **User Complaints**: Slow application response

</details>

---

## ❓ Interview Question

> **"Why can load be high with low CPU, and how will you debug?"**

<details>
<summary><b>What the Interviewer is Evaluating</b></summary>

✓ Understanding of load average vs CPU utilization  
✓ Knowledge of I/O wait and blocking processes  
✓ Familiarity with Linux monitoring tools  
✓ Understanding of process states  
✓ Root cause analysis skills
</details>

---

## 🔍 Troubleshooting Approach

<details>
<summary><b>Step 1: Check Load vs CPU</b></summary>

```bash
uptime  # Shows load average
top     # Shows CPU and I/O wait percentage
vmstat 1 5  # Shows I/O wait
iostat -x 1  # Disk metrics
```

</details>

<details>
<summary><b>Step 2: Identify Processes in D State</b></summary>

```bash
ps -eo pid,stat,cmd | grep ' D '
# D = uninterruptible sleep (waiting for I/O)
dmesg | tail
# Check for errors
```

</details>

<details>
<summary><b>Step 3: Analyze Disk and NFS Issues</b></summary>

```bash
iostat -x 1  # Check disk saturation
iotop        # Per-process I/O
mount | grep nfs  # Check NFS mounts
```

</details>

---

## 🎯 Root Cause Possibilities

<details>
<summary><b>Expand to see all possible causes</b></summary>

| Root Cause | How to Identify | Fix |
|-----------|-----------------|-----|
| **Disk I/O Bottleneck** | High %util in iostat | Optimize queries, add SSD |
| **NFS Slow** | D state processes, slow mounts | Fix NFS server, check network |
| **Slow EBS** | High await time | Increase IOPS |
| **RAID Rebuild** | High disk I/O | Wait for rebuild to complete |
| **Heavy Swap** | Swap usage high | Add RAM, optimize memory |

</details>

---

## ✅ Prevention & Best Practices

<details>
<summary><b>How to prevent this issue</b></summary>

- ✓ Monitor I/O wait percentage separately
- ✓ Alert on high load + low CPU combination
- ✓ Use SSD for databases
- ✓ Optimize database queries with indexes

</details>

---

## 💬 Sample Spoken Answer

<details>
<summary><b>Click to reveal full interview answer</b></summary>

**"This is a classic I/O-bound scenario. Load includes processes waiting for disk/network I/O, not just CPU processes.**

**My approach:**
1. Run `uptime` to confirm high load
2. Run `top` to check I/O wait percentage ('wa')
3. Run `iostat -x` to see disk utilization
4. If disk is saturated, check which process with `iotop`
5. If NFS is slow, check mount points and network

**Common causes:** slow disk, NFS timeout, missing indexes, swap thrashing

**Solutions:** optimize queries, add SSD, fix NFS, add RAM"

</details>

---

**Last Updated**: January 28, 2026 | **Difficulty**: Medium | **Time to Read**: 3 min

## Prevention / best practices
- IO monitoring, right EBS type/IOPS, caching, queue depth tuning, SLO alerts.

## Sample spoken answer
"High load with low CPU usually means many processes are waiting—often on disk or network storage. I'll check vmstat and iostat -x for IO wait and disk utilization. Then I'll look for D-state processes. If storage latency is the issue, I'll reduce IO pressure, verify EBS metrics, and scale IOPS or move to faster volumes. After mitigation, I'll add dashboards for IO wait and disk latency."