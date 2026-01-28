# CI/CD: Docker Image Pull Fails in Production

## Scenario
New pods fail with ImagePullBackOff.

## Interview question
"How do you troubleshoot image pull failures?"

## What interviewer evaluates
Registry auth, image tag, network, permissions.

## Troubleshooting approach
- Check pod events
- Validate image name/tag exists
- Check registry credentials (ECR token, imagePullSecret)
- Verify node can reach registry endpoints
- Check IAM role permissions for ECR

## Commands / tools
```
kubectl describe pod <pod>
kubectl get events
aws ecr describe-images --repository-name <repo>
```

## Root cause possibilities
- Wrong tag, missing push, expired auth, IAM missing, private endpoint/DNS issue.

## Prevention / best practices
- Immutable tags, deploy only after push validation, ECR permissions via roles, pre-pull tests.

## Sample spoken answer
"I'll start with kubectl describe pod to see the exact pull error. Then I'll confirm the image tag exists in the registry. If it's auth, I'll fix ECR permissions or imagePullSecret and ensure nodes can reach ECR endpoints. After recovery, I'll enforce immutable tags and make the pipeline verify image availability before deployment."