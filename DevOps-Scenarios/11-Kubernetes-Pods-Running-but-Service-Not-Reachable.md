# 🔧 Kubernetes: Pods Running but Service Not Reachable

> **Difficulty Level**: ⭐⭐ (Intermediate) | **Time to Resolve**: 10-15 min | **Business Impact**: High (Users cannot access service)

---

## 📋 Scenario

Pods are showing `Running` status and appear healthy, but users cannot reach the service. The application is deployed but is completely unreachable from outside or even from within the cluster.

<details>
<summary><b>View Full Scenario Details</b></summary>

- **Symptom**: `Connection refused` or `No route to host` errors
- **Current State**: Pods running, but service returns no response
- **User Impact**: Customers cannot access the application
- **Timeline**: Issue just appeared after a new deployment
</details>

---

## ❓ Interview Question

> **"How do you troubleshoot Kubernetes service connectivity?"**

<details>
<summary><b>What the Interviewer is Evaluating</b></summary>

✓ Understanding of Kubernetes service architecture  
✓ Ability to diagnose networking issues systematically  
✓ Knowledge of selectors, endpoints, and port mappings  
✓ Familiarity with debugging tools (kubectl, curl, logs)  
✓ Understanding of network policies and security groups  
✓ Communication skills during troubleshooting
</details>

---

## 🔍 Troubleshooting Approach

### Step-by-Step Diagnosis

<details>
<summary><b>Step 1: Check Service and Endpoints</b></summary>

```bash
# List all services in the namespace
kubectl get svc -n <namespace>

# Get detailed service information
kubectl describe svc <service-name> -n <namespace>

# Check if endpoints exist (most important!)
kubectl get endpoints <service-name> -n <namespace>
```

**What to look for:**
- ✓ Service has an assigned ClusterIP
- ✓ Endpoints list shows pod IPs
- ⚠️ Empty endpoints = selector or readiness problem

</details>

<details>
<summary><b>Step 2: Validate Pod Labels and Selectors</b></summary>

```bash
# Get pods with labels
kubectl get pods -n <namespace> --show-labels

# Get service selector
kubectl get svc <service-name> -n <namespace> -o yaml | grep -A 3 selector
```

**Verification:**
- Pod labels must **exactly match** service selector
- Case-sensitive comparison
- Check for extra spaces or typos

</details>

<details>
<summary><b>Step 3: Verify Port Configuration</b></summary>

```bash
# Check service and container ports
kubectl describe svc <service-name> -n <namespace>

# Compare with pod definition
kubectl describe pod <pod-name> -n <namespace> | grep -A 2 "Ports:"

# Check containerPort in deployment
kubectl describe deploy <deployment-name> -n <namespace>
```

**Port Matching Checklist:**
- Service `port` = exposed port (can be anything)
- Service `targetPort` = container port in pod
- Container `containerPort` = port app listens on
- All must align correctly

</details>

<details>
<summary><b>Step 4: Test Connectivity from Inside Cluster</b></summary>

```bash
# Run a test pod
kubectl run -it --rm debug --image=alpine --restart=Never -- /bin/sh

# Inside the pod, test connectivity
nslookup <service-name>
curl -v http://<service-name>:<port>
curl -v http://<service-ip>:<port>

# Or direct pod IP
kubectl exec -it <pod-name> -n <namespace> -- curl -v http://<pod-ip>:<port>
```

**Success Indicators:**
- DNS resolves service name to ClusterIP
- curl to service succeeds
- curl to pod IP succeeds

</details>

<details>
<summary><b>Step 5: Check Network Policies (EKS/Advanced)</b></summary>

```bash
# List network policies
kubectl get networkpolicies -n <namespace>

# Check if any policies block traffic
kubectl describe networkpolicy <policy-name> -n <namespace>

# For EKS, check security groups
aws ec2 describe-security-groups --filters Name=group-name,Values=<sg-name>

# Test connectivity without network policies
kubectl run -it --rm debug --image=alpine --restart=Never --labels=debug=true -- /bin/sh
```

**Verification:**
- No ingress policies denying traffic
- Pod selector allows traffic from other pods
- EKS security groups allow communication

</details>

---

## 🛠️ Commands & Tools Reference

<details>
<summary><b>Essential kubectl Commands</b></summary>

```bash
# Service diagnostics
kubectl get svc
kubectl describe svc <svc>
kubectl get endpoints <svc>
kubectl get svc <svc> -o yaml

# Pod diagnostics  
kubectl get pods --show-labels
kubectl describe pod <pod>
kubectl exec -it <pod> -- /bin/sh

# Networking tests
kubectl run -it --rm debug --image=alpine --restart=Never -- sh
curl -v http://<service>:<port>
nslookup <service>

# DNS check
kubectl get svc kube-dns -n kube-system
kubectl logs -n kube-system -l k8s-app=kube-dns

# Event logs
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

</details>

<details>
<summary><b>Debugging Tools</b></summary>

- **kubectl**: Primary Kubernetes CLI
- **curl/wget**: HTTP connectivity testing
- **nslookup/dig**: DNS resolution testing
- **netstat/ss**: Network socket information
- **tcpdump**: Packet capture for deep analysis
- **Nicolas Mesh**: For service mesh debugging

</details>

---

## 🎯 Root Cause Possibilities

<details>
<summary><b>Expand to see all possible root causes</b></summary>

| Root Cause | How to Identify | Fix |
|-----------|-----------------|-----|
| **Wrong Service Selector** | Endpoints empty | Fix selector in service YAML to match pod labels |
| **Readiness Probe Failing** | Pods Running but not Ready | Fix readiness probe in pod spec or check app health |
| **Port Mismatch** | Ports don't align | Match targetPort to containerPort |
| **NetworkPolicy Blocking** | Policy exists with restrictive rules | Allow traffic in NetworkPolicy ingress rules |
| **Service Type Wrong** | Using ClusterIP when need NodePort | Change service type if external access needed |
| **Pod Not Ready** | Pod appears Running but not healthy | Check logs: `kubectl logs <pod>` |
| **Service Not in Cluster** | Service doesn't exist | Create service manifest |
| **Typo in Service Name** | DNS doesn't resolve | Verify service name spelling |

</details>

---

## ✅ Prevention & Best Practices

<details>
<summary><b>How to prevent this issue in the future</b></summary>

### Development Phase
- ✓ Use Helm with validation enabled
- ✓ Validate YAML before deployment: `kubectl apply -f file.yaml --dry-run=client`
- ✓ Unit test service selectors in dev environment

### Testing Phase
- ✓ Integration tests for service connectivity
- ✓ Test from pod-to-pod using init containers
- ✓ Verify all port configurations match

### Deployment Phase
- ✓ Use standard label conventions (e.g., `app: myapp`, `version: v1`)
- ✓ Document port configuration in runbooks
- ✓ Review NetworkPolicy changes in code review

### Monitoring Phase
- ✓ Monitor endpoint count per service
- ✓ Alert if endpoints become 0
- ✓ Log service connectivity tests

### Documentation
- ✓ Maintain service dependency map
- ✓ Document port allocation scheme
- ✓ Create runbooks for common issues

</details>

---

## 💬 Sample Spoken Answer

<details>
<summary><b>Click to reveal full interview answer</b></summary>

**"I'll troubleshoot this systematically:**

**First**, I'll check if the service has endpoints:
```bash
kubectl get endpoints <service-name>
```
If endpoints are empty, it's a selector problem.

**Second**, I'll verify the selector matches pod labels:
```bash
kubectl get pods --show-labels
kubectl describe svc <service-name>
```
The selector keys and values must exactly match pod labels.

**Third**, I'll confirm port alignment:
- Service targetPort must equal pod containerPort
- I'll verify this in the service and deployment YAML

**Fourth**, I'll test connectivity from within a pod:
```bash
kubectl exec -it <pod> -- curl -v http://<service>:<port>
```
If this works, it's external access issue. If it fails, it's service config.

**Finally**, I'll check for NetworkPolicies or EKS security groups blocking traffic.

**The fix depends on root cause:**
- Selector mismatch → fix labels
- Port mismatch → fix YAML port configuration  
- Readiness failing → debug app or health check
- NetworkPolicy blocking → allow traffic in policy

**Prevention:**
- Use Helm with validation
- Test selectors in staging
- Monitor endpoint count
- Document port configurations
- Review changes in code review"

</details>

---

## 📊 Quick Decision Tree

```
Service not reachable?
│
├─→ kubectl get endpoints shows IPs?
│   ├─→ YES → Port or NetworkPolicy issue
│   │         └─→ Check port config and NetworkPolicies
│   │
│   └─→ NO → Selector or Readiness issue
│            ├─→ Check labels match selector
│            ├─→ Check pod readiness
│            └─→ Check pod logs
│
└─→ Can connect from pod but not externally?
    └─→ Check service type (ClusterIP vs NodePort/LoadBalancer)
```

---

## 🎓 Interview Tips

<details>
<summary><b>How to impress the interviewer</b></summary>

✅ **Do:**
- Ask clarifying questions (which namespace? is this EKS?)
- Explain each step before running commands
- Show you understand the service architecture
- Mention both quick diagnosis and root cause analysis
- Discuss prevention and monitoring

❌ **Don't:**
- Jump to conclusions without checking logs
- Blame the network without verification
- Forget to check readiness probes
- Ignore NetworkPolicy considerations
- Rush through the diagnosis

**Bonus Points:**
- Mention using Helm values validation
- Discuss testing in staging first
- Reference your experience with similar issues
- Suggest monitoring improvements

</details>

---

## 📚 Related Scenarios

- [Kubernetes: Nodes Not Ready Suddenly](12-Kubernetes-Nodes-Not-Ready-Suddenly.md)
- [Kubernetes: HPA Not Scaling Even When CPU Is High](17-Kubernetes-HPA-Not-Scaling-Even-When-CPU-Is-High.md)
- [CI-CD: Docker Image Pull Fails in Production](18-CI-CD-Docker-Image-Pull-Fails-in-Production.md)

---

**Last Updated**: January 28, 2026 | **Difficulty**: Medium | **Time to Read**: 5 min