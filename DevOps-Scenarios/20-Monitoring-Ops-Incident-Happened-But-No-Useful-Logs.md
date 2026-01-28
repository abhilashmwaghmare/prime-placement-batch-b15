# Monitoring + Ops: Incident Happened, But No Useful Logs

## Scenario
Service had a 20-minute outage, but logs are missing or incomplete. Hard to find root cause.

## Interview question
"How do you design observability to avoid this situation?"

## What interviewer evaluates
Logging, metrics, tracing, retention, correlation IDs.

## Troubleshooting approach
- Ensure logs are centralized and retained
- Add structured logs + correlation/request IDs
- Add key metrics: error rate, latency, saturation
- Add tracing for distributed services
- Ensure alerts link to dashboards and runbooks

## Commands / tools
CloudWatch Logs, ELK/OpenSearch, Prometheus/Grafana, X-Ray/Jaeger.

## Root cause possibilities
- No central logging, short retention, no correlation IDs, no trace.

## Prevention / best practices
- Standard observability baseline, retention policies, sampling strategy, incident runbooks.

## Sample spoken answer
"If we can't debug due to missing logs, the fix is observability. I'll centralize logs with proper retention, use structured logging and correlation IDs, and create dashboards for latency, errors, and saturation. For microservices, I'll add tracing to see where time is spent. Finally, I'll connect alerts to runbooks and dashboards so incidents become faster to resolve."