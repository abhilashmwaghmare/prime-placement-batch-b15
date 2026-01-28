# AWS Networking: Private Subnet Instances Can't Reach Internet

## Scenario
EC2 in private subnet cannot download packages. Public subnet works.

## Interview question
"What components do you check?"

## What interviewer evaluates
NAT gateway, route tables, NACL/SG, DNS.

## Troubleshooting approach
- Verify route table has 0.0.0.0/0 to NAT
- NAT gateway in public subnet with EIP
- NACL rules allow outbound
- Security group egress
- DNS resolution

## Commands / tools
AWS VPC console, reachability analyzer. On instance:

```
curl -I https://example.com
nslookup google.com
ip route
```

## Root cause possibilities
- No NAT route, NAT deleted, NACL blocking, DNS misconfig.

## Prevention / best practices
- Infra as code, monitoring NAT, multi-AZ NAT, route checks.

## Sample spoken answer
"For private subnet internet access, I'll check the route table for default route to NAT gateway. Then confirm NAT is in a public subnet with an EIP and its route table points to the IGW. I'll verify NACL and SG egress and confirm DNS resolution. Once fixed, I'll keep it in IaC and add checks so NAT/route issues are detected early."