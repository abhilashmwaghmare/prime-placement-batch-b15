# Kubernetes: HPA Not Scaling Even When CPU Is High

## Scenario
CPU is 90% but HPA is not scaling.

## Interview question
"What do you check in HPA failures?"

## What interviewer evaluates
Metrics server, requests/limits, HPA config.

## Troubleshooting approach
- Check HPA status/events
- Confirm metrics-server working
- Ensure CPU requests set (HPA needs requests)
- Check scale limits and target utilization

## Commands / tools
```
kubectl get hpa
kubectl describe hpa <name>
kubectl top pods
kubectl top nodes
```

## Root cause possibilities
- No metrics-server, missing CPU requests, wrong target, max replicas reached.

## Prevention / best practices
- Baseline requests/limits, metrics health checks, HPA testing.

## Sample spoken answer
"I'll inspect kubectl describe hpa to see why it's not scaling. Usually metrics-server issues or missing CPU requests cause this. I'll verify metrics availability using kubectl top. Then ensure CPU requests are defined and HPA targets are correct. Finally, I'll test HPA behavior in staging and keep metrics-server monitored."