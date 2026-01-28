# Docker: Container Keeps Restarting in Production

## Scenario
A container in ECS/K8s shows CrashLoopBackOff / restarting every few seconds.

## Interview question
"How do you debug a restarting container?"

## What interviewer evaluates
Logs, exit code, probes, resources.

## Troubleshooting approach
- Check container logs
- Check exit code / reason
- Validate env vars and secrets
- Check liveness/readiness probes
- Check CPU/memory limits and OOM kills

## Commands / tools
K8s:

```
kubectl describe pod <pod>
kubectl logs <pod> --previous
kubectl get events --sort-by=.metadata.creationTimestamp
```

Docker:

```
docker logs <id>
docker inspect <id>
```

## Root cause possibilities
- Bad config, missing secret, app crash, OOMKilled, failing probes.

## Prevention / best practices
- Proper probes, resource sizing, config validation, start-up delay, better error handling.

## Sample spoken answer
"I'll start with kubectl describe and kubectl logs --previous to see why it exited. Then I'll verify config/secrets and check if it's OOMKilled or probe failures. If probes are too aggressive, I'll adjust initial delay and thresholds. If it's real crash, I'll fix the app or config and redeploy."