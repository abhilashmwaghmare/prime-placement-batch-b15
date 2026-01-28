# Linux: Disk 100% Full, App Down

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