# DevOps Troubleshooting Scenarios

This repository contains a collection of common DevOps troubleshooting scenarios, each documented in a separate Markdown file. These are based on real-world production issues and interview questions, covering Linux, AWS, Kubernetes, Docker, CI/CD, Monitoring, and Security topics.

## Scenarios

1. [Linux: Disk 100% Full, App Down](01-Linux-Disk-100-Full-App-Down.md)
2. [Linux: High Load but CPU Not High](02-Linux-High-Load-but-CPU-Not-High.md)
3. [Linux: Server Reachable, Port Closed Suddenly](03-Linux-Server-Reachable-Port-Closed-Suddenly.md)
4. [Linux: "No Space Left" but df -h Shows Free Space](04-Linux-No-Space-Left-but-df-h-Shows-Free-Space.md)
5. [AWS: EC2 Auto Scaling Not Launching Instances](05-AWS-EC2-Auto-Scaling-Not-Launching-Instances.md)
6. [AWS: Sudden Cost Spike Overnight](06-AWS-Sudden-Cost-Spike-Overnight.md)
7. [AWS: ALB Healthy but Users Still Fail](07-AWS-ALB-Healthy-but-Users-Still-Fail.md)
8. [AWS: RDS CPU High and App Slow](08-AWS-RDS-CPU-High-and-App-Slow.md)
9. [CI/CD: Deployment Succeeded but App Broken](09-CI-CD-Deployment-Succeeded-but-App-Broken.md)
10. [Docker: Container Keeps Restarting in Production](10-Docker-Container-Keeps-Restarting-in-Production.md)
11. [Kubernetes: Pods Running but Service Not Reachable](11-Kubernetes-Pods-Running-but-Service-Not-Reachable.md)
12. [Kubernetes: Nodes Not Ready Suddenly](12-Kubernetes-Nodes-Not-Ready-Suddenly.md)
13. [Monitoring: Alerts Fire but No Real Issue (Noise)](13-Monitoring-Alerts-Fire-but-No-Real-Issue-Noise.md)
14. [Security: IAM Key Leaked on GitHub](14-Security-IAM-Key-Leaked-on-GitHub.md)
15. [AWS Networking: Private Subnet Instances Can't Reach Internet](15-AWS-Networking-Private-Subnet-Instances-Can-t-Reach-Internet.md)
16. [DevOps: Secrets Worked Yesterday, Today App Fails Auth](16-DevOps-Secrets-Worked-Yesterday-Today-App-Fails-Auth.md)
17. [Kubernetes: HPA Not Scaling Even When CPU Is High](17-Kubernetes-HPA-Not-Scaling-Even-When-CPU-Is-High.md)
18. [CI/CD: Docker Image Pull Fails in Production](18-CI-CD-Docker-Image-Pull-Fails-in-Production.md)
19. [AWS: S3 Access Denied After Policy Change](19-AWS-S3-Access-Denied-After-Policy-Change.md)
20. [Monitoring + Ops: Incident Happened, But No Useful Logs](20-Monitoring-Ops-Incident-Happened-But-No-Useful-Logs.md)

Each scenario includes:
- A production scenario description
- Interview question
- What the interviewer evaluates
- Troubleshooting steps
- Commands/tools used
- Possible root causes
- Prevention/best practices
- Sample spoken answer

These documents are useful for learning DevOps troubleshooting, preparing for interviews, or as reference guides for on-call engineers.


Managing Users and Permissions in Linux


- Importance of Password Security
- Using passwd Command
- Password Policy Settings
- Account Locking and Expiration
- Understanding /etc/shadow fields
- Using chage Command
- Introduction to Linux Groups
- Fields of /etc/group and /etc/gshadow
- Types of Groups
- Creating and Deleting Groups
- Modifying Groups
- Managing group Memberships
- Viewing and Editing Group Information