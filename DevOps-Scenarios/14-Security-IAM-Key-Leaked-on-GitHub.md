# Security: IAM Key Leaked on GitHub

## Scenario
A developer accidentally pushed AWS access key to a public repo.

## Interview question
"What are your immediate steps and long-term actions?"

## What interviewer evaluates
Incident response, IAM best practices.

## Troubleshooting approach
- Disable/rotate the key immediately
- Check CloudTrail for suspicious activity
- Identify resources created/changed
- Add SCP/permissions boundaries if possible
- Implement secret scanning and least privilege

## Commands / tools
IAM, CloudTrail, AWS Config, GitHub secret scanning.

## Root cause possibilities
- Hardcoded secrets, no scanning, poor processes.

## Prevention / best practices
- Use IAM roles, AWS SSO, secret manager, pre-commit hooks, CI scanning.

## Sample spoken answer
"First I'll deactivate the leaked key and rotate credentials. Then I'll review CloudTrail to see if it was used and what actions happened. I'll revert any unauthorized changes. After containment, I'll enforce least privilege, move secrets to a secret manager, and enable secret scanning in repos and CI to prevent recurrence."