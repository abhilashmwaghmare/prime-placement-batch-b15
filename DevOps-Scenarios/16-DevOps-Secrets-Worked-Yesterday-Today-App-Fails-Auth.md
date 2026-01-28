# DevOps: Secrets Worked Yesterday, Today App Fails Auth

## Scenario
After a restart, app cannot authenticate to DB. It worked yesterday.

## Interview question
"How do you debug secret/config issues?"

## What interviewer evaluates
Secret lifecycle, rotation, env consistency.

## Troubleshooting approach
- Check if secret changed/rotated
- Verify app is reading correct secret name/version
- Check permissions to read secret
- Verify config in deployment
- Test connectivity manually from pod/instance

## Commands / tools
AWS Secrets Manager/SSM, K8s secrets, IAM roles, app logs.

## Root cause possibilities
- Secret rotation not handled, wrong secret reference, permission removed, config drift.

## Prevention / best practices
- Standard secret rotation strategy, automated reload, config audits, IaC.

## Sample spoken answer
"I'll check logs to confirm auth failure and verify if secrets were rotated. Then I'll confirm the application is referencing the correct secret/version and has IAM permission. I'll test DB connection from inside the runtime. After fixing, I'll ensure rotation is handled properly and avoid config drift using IaC and audits."