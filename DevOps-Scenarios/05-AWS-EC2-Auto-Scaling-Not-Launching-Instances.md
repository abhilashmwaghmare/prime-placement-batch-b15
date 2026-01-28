# AWS: EC2 Auto Scaling Not Launching Instances

## Scenario
Traffic spike. ASG desired capacity increases, but instances are not coming up.

## Interview question
"How do you troubleshoot ASG launch failures?"

## What interviewer evaluates
ASG events, IAM, quotas, subnets, AMI.

## Troubleshooting approach
- Check ASG Activity history/events
- Check Launch Template (AMI, SG, key, user-data)
- Check subnet capacity + IPs
- Check EC2 quota / vCPU limits
- Check IAM instance profile permissions

## Commands / tools
ASG Activity, EC2 console, CloudTrail, Service Quotas, CloudWatch.

## Root cause possibilities
- No IPs in subnet, instance type unavailable, quota hit, bad AMI, user-data failing.

## Prevention / best practices
- Multi-AZ/subnet, mixed instance policy, quota alerts, golden AMI pipeline, launch test.

## Sample spoken answer
"I'll open the ASG activity history to see the exact failure reason. Then I'll validate launch template settings, subnet IP availability, and service quotas. If instance type capacity is an issue, I'll enable mixed instances and multiple AZs. If user-data/AMI is broken, I'll test the AMI and fix bootstrap. Finally, I'll add quota and subnet-IP monitoring."