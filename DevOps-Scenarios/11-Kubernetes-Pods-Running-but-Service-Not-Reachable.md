# Kubernetes: Pods Running but Service Not Reachable

## Scenario
Pods are Running, but service returns no response.

## Interview question
"How do you troubleshoot Kubernetes service connectivity?"

## What interviewer evaluates
Selectors, endpoints, ports, network policies.

## Troubleshooting approach
- Validate service selector matches pod labels
- Check endpoints are created
- Confirm container port vs service targetPort
- Test inside cluster (curl)
- Check NetworkPolicy / security group rules (EKS)

## Commands / tools
```
kubectl get svc
kubectl describe svc <svc>
kubectl get endpoints <svc>
kubectl get pods --show-labels
kubectl exec -it <pod> -- curl -v http://<svc>:<port>
```

## Root cause possibilities
- Wrong selector, wrong port mapping, readiness failing, NetworkPolicy blocking.

## Prevention / best practices
- Helm validations, integration tests, standard labels, policy review.

## Sample spoken answer
"I'll check if the service selector matches pod labels and confirm endpoints exist. If endpoints are empty, selector or readiness is wrong. Then I'll confirm service port and targetPort match the container port. I'll test connectivity from a pod. If still failing, I'll review NetworkPolicies and EKS security groups."