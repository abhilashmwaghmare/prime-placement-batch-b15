# Linux: "No Space Left" but df -h Shows Free Space

## Scenario
App fails with "No space left on device", but disk shows 40% free.

## Interview question
"What can cause this and how do you confirm?"

## What interviewer evaluates
Inodes and deleted-open files.

## Troubleshooting approach
- Check inode usage
- Check deleted but open files
- Check reserved blocks (ext)

## Commands / tools
```
df -i
lsof +L1
tune2fs -l /dev/xvda1 | grep -i reserved
```

## Root cause possibilities
- Inode exhaustion (many small files), open deleted logs, reserved blocks.

## Prevention / best practices
- Limit temp files, rotate logs, clean temp directories, monitor inodes.

## Sample spoken answer
"If df -h shows space but app says no space, I'll check df -i for inode exhaustion. Next I'll run lsof +L1 to find large files deleted but still held open. Fix is removing excessive small files or restarting the process holding deleted logs. I'll also add inode alerts and cleanup policies."