# AWS: Sudden Cost Spike Overnight

## Scenario
Finance reports AWS bill jumped 2x in one day.

## Interview question
"How do you find the cost driver quickly and stop bleeding?"

## What interviewer evaluates
Cost tools + triage.

## Troubleshooting approach
- Check Cost Explorer daily + service breakdown
- Look for new resources: NAT GW, data transfer, EBS, CloudWatch logs, EKS
- Use CloudTrail for who created resources
- Apply immediate controls: stop/limit, budgets, SCP (if org)

## Commands / tools
Cost Explorer, CUR, Budgets, CloudTrail, AWS Config.

## Root cause possibilities
- NAT gateway data processing, runaway logs, misconfigured autoscaling, snapshot growth, data egress.

## Prevention / best practices
- Budgets + alerts, tagging, guardrails, log retention, architecture review.

## Sample spoken answer
"I'll start with Cost Explorer to identify which service increased and on which day. Then I'll drill into usage type—often NAT data processing or logs. I'll use CloudTrail to see what changed and who created it. I'll stop or limit the offending resource immediately, then put budgets and alerts and enforce tagging so we catch it early next time."