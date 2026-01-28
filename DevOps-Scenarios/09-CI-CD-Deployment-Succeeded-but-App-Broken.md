# CI/CD: Deployment Succeeded but App Broken

## Scenario
Pipeline is green. After deploy, login fails for all users.

## Interview question
"How do you handle 'successful deploy' but failed production functionality?"

## What interviewer evaluates
Rollback strategy, validation, canary.

## Troubleshooting approach
- Confirm incident and scope
- Check release notes + diff
- Check app logs, config/secrets changes
- Rollback quickly to last known good version
- Add smoke tests and post-deploy checks

## Commands / tools
Git, CI logs, Kubernetes rollout history, feature flags.

## Root cause possibilities
- Env var missing, DB migration issue, wrong config, backward incompatibility.

## Prevention / best practices
- Smoke tests, canary/blue-green, feature flags, migration strategy.

## Sample spoken answer
"If prod is broken, first I'll restore service fast—usually rollback to last stable release. Then I'll investigate logs and config changes to identify what caused login failure. Many times it's missing secrets or incompatible migrations. After fixing, I'll add smoke tests and post-deploy validations and prefer canary releases to reduce blast radius."