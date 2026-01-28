# Linux: High Load but CPU Not High

## Scenario
Load average jumped to 30, but CPU usage is ~20%. App response time is high.

## Interview question
"Why load can be high with low CPU, and how will you debug?"

## What interviewer evaluates
Understanding of load vs CPU, IO wait, blocked processes.

## Troubleshooting approach
- Check load/CPU (uptime, top)
- Check IO wait (iostat, vmstat)
- Identify processes in D state (uninterruptible sleep)
- Check disk saturation, NFS issues, DB storage latency

## Commands / tools
```
uptime
top
vmstat 1
iostat -x 1
ps -eo pid,stat,cmd | grep ' D '
dmesg | tail
```

## Root cause possibilities
- Disk IO bottleneck, NFS hang, slow EBS, RAID rebuild, heavy swap.

## Prevention / best practices
- IO monitoring, right EBS type/IOPS, caching, queue depth tuning, SLO alerts.

## Sample spoken answer
"High load with low CPU usually means many processes are waiting—often on disk or network storage. I'll check vmstat and iostat -x for IO wait and disk utilization. Then I'll look for D-state processes. If storage latency is the issue, I'll reduce IO pressure, verify EBS metrics, and scale IOPS or move to faster volumes. After mitigation, I'll add dashboards for IO wait and disk latency."