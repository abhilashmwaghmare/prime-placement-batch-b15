# Monitoring: Alerts Fire but No Real Issue (Noise)

## Scenario
Pager alerts every hour, but services are fine. Team is getting alert fatigue.

## Interview question
"How do you reduce noise without missing real incidents?"

## What interviewer evaluates
SLO thinking, alert tuning.

## Troubleshooting approach
- Identify top noisy alerts
- Validate if they map to user impact
- Increase thresholds / add duration
- Add correlation (multiple signals)
- Use warning vs critical levels

## Commands / tools
CloudWatch alarms, Prometheus alert rules, Grafana dashboards.

## Root cause possibilities
- Too sensitive thresholds, missing "for" time, single-metric alerts.

## Prevention / best practices
- SLO-based alerts, runbooks, periodic tuning.

## Sample spoken answer
"I'll review the noisiest alerts and check if they reflect customer impact. Then I'll tune them using time windows and correct thresholds, and require confirmation from multiple signals—like latency plus error rate. I'll keep warnings for investigation and reserve critical alerts for real outages. This reduces fatigue and improves response quality."