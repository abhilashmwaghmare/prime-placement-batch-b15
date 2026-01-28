# AWS: ALB Healthy but Users Still Fail

## Scenario
ALB shows targets healthy, but customers still get 502 or timeouts intermittently.

## Interview question
"How do you debug intermittent ALB errors?"

## What interviewer evaluates
Understanding of target health vs app readiness, timeouts, logs.

## Troubleshooting approach
- Enable/inspect ALB access logs
- Check target group health check path
- Verify app response time and backend timeouts
- Check security groups/NACL
- Verify idle timeout, keep-alive, upstream timeouts

## Commands / tools
ALB access logs (S3), CloudWatch metrics, target group settings.

## Root cause possibilities
- Health check too shallow, app thread pool exhausted, wrong timeout values, connection resets.

## Prevention / best practices
- Better health checks (dependency checks), autoscaling, timeout tuning, dashboards.

## Sample spoken answer
"Healthy targets only means health check passes. I'll enable ALB access logs and correlate 502s with target response times and status codes. Then I'll confirm health check path is meaningful and check backend timeouts and ALB idle timeout. If it's capacity, I'll scale targets and tune app pools. Finally I'll improve health checks and add SLO alerts."