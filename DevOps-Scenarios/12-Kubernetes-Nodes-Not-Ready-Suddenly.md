# Kubernetes: Nodes Not Ready Suddenly

## Scenario
Multiple nodes became NotReady, pods evicted, traffic dropped.

## Interview question
"What do you check when nodes go NotReady?"

## What interviewer evaluates
Node health, kubelet, disk pressure, networking.

## Troubleshooting approach
- Check node conditions
- Inspect kubelet logs (if access)
- Check disk pressure/inodes
- Check CNI issues
- Check AWS node status (EKS/EC2)

## Commands / tools
```
kubectl describe node <node>
kubectl get nodes
kubectl get events -A | tail
```

AWS: EC2 status checks, CloudWatch.

## Root cause possibilities
- Disk full, kubelet crash, CNI failure, instance network issue, too many pods.

## Prevention / best practices
- Node monitoring, disk cleanup, proper limits, managed node groups, PDBs.

## Sample spoken answer
"I'll run kubectl describe node to see if it's DiskPressure, MemoryPressure, or network. Then I'll check recent cluster events and correlate with EC2 status checks. If it's disk pressure, I'll clean disk/logs and ensure eviction thresholds are correct. If it's CNI, I'll verify the plugin health. Then I'll improve node monitoring and capacity planning."