# AWS: RDS CPU High and App Slow

## Scenario
RDS CPU is 90% and API latency increased.

## Interview question
"How will you troubleshoot RDS performance?"

## What interviewer evaluates
Metrics, slow queries, connections.

## Troubleshooting approach
- Check CloudWatch: CPU, FreeableMemory, Read/Write IOPS, Connections
- Enable Performance Insights
- Find top SQL and wait events
- Check connection pool, long-running queries
- Add indexes / optimize queries; scale if needed

## Commands / tools
CloudWatch, Performance Insights, Enhanced Monitoring.

## Root cause possibilities
- Missing indexes, bad query plan, sudden traffic, connection leak, autovacuum issues (Postgres), locks.

## Prevention / best practices
- Query reviews, indexes, PI alarms, pool settings, read replicas, caching.

## Sample spoken answer
"I'll first check RDS metrics to understand if the bottleneck is CPU, memory, or IO. Then I'll use Performance Insights to identify top SQL and wait events. If queries are slow, I'll optimize indexes and fix expensive queries. If connections are too many, I'll fix pooling. For immediate relief, I might scale instance or add read replicas, and later improve query performance and add alerts."