# AWS: S3 Access Denied After Policy Change

## Scenario
App suddenly gets 403 AccessDenied on S3 uploads after a change.

## Interview question
"How do you debug S3 permission issues?"

## What interviewer evaluates
IAM + bucket policy + KMS + block public access.

## Troubleshooting approach
- Identify which identity is used (role/user)
- Review IAM policy permissions (PutObject, ListBucket)
- Check bucket policy conditions
- Check KMS permissions if SSE-KMS
- Verify endpoint policy if using VPC endpoint

## Commands / tools
IAM policy simulator, CloudTrail, S3 bucket policy, KMS key policy.

## Root cause possibilities
- Explicit deny in bucket policy, missing KMS permissions, wrong prefix condition, endpoint policy deny.

## Prevention / best practices
- Change review, policy tests, least privilege templates, automated checks.

## Sample spoken answer
"I'll confirm the role used by the app and then simulate permissions using IAM policy simulator. I'll check both IAM policy and bucket policy for explicit denies and conditions. If encryption uses KMS, I'll ensure the role can use the key. If traffic goes via VPC endpoint, I'll review endpoint policy. After fixing, I'll add policy tests and change controls."