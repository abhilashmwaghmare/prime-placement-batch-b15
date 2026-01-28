# Scenario-Based and Troubleshooting Interview Questions and Answers

This document contains real-time scenario-based and troubleshooting interview questions and answers for various DevOps and related technologies. (Interactive: click to expand each scenario)

## Linux

<details><summary>High Memory Usage Leading to OOM</summary>

#### Scenario
Application memory keeps growing, server OOM kills processes.

#### Interview question
"How do you troubleshoot memory leaks on Linux?"

#### What interviewer evaluates
Memory management, profiling.

#### Troubleshooting approach
- Monitor memory with free/vmstat
- Identify high mem processes
- Profile with tools

#### Commands / tools
```
free -h
ps aux --sort=-%mem
pmap -x <pid>
valgrind (in dev)
```

#### Root cause possibilities
- Code leaks, not freeing memory.

#### Prevention / best practices
- Code profiling, limits, monitoring.

#### Sample spoken answer
"Use free to see memory. ps for top processes. pmap for details. In dev, valgrind. Fix code or restart."

</details>

## DevOps

<details><summary>Git Branch Protection Bypassed</summary>

#### Scenario
Protected branch merged without approval.

#### Interview question
"Why was branch protection bypassed?"

#### What interviewer evaluates
Git policies, enforcement.

#### Troubleshooting approach
- Check protection rules
- Audit logs
- Admin overrides

#### Commands / tools
GitHub audit log

#### Root cause possibilities
- Rules not set, admin merge.

#### Prevention / best practices
- Strict rules, education.

#### Sample spoken answer
"Check branch protection settings. Audit who merged."

</details>

## Kubernetes

<details><summary>PVC Pending</summary>

#### Scenario
PVC stuck in Pending.

#### Interview question
"Why is PVC pending?"

#### What interviewer evaluates
Storage classes, provisioners.

#### Troubleshooting approach
- Check events
- Storage class
- Provisioner status

#### Commands / tools
kubectl describe pvc, kubectl get sc

#### Root cause possibilities
- No provisioner, quota.

#### Prevention / best practices
- Verify storage setup.

#### Sample spoken answer
"kubectl describe pvc. Check events for errors."

</details>

<details><summary>Ingress Not Routing</summary>

#### Scenario
Ingress not routing traffic.

#### Interview question
"Troubleshoot ingress routing."

#### What interviewer evaluates
Ingress config, controller.

#### Troubleshooting approach
- Check ingress rules
- Controller logs
- Annotations

#### Commands / tools
kubectl describe ingress, controller logs

#### Root cause possibilities
- Wrong rules, controller issues.

#### Prevention / best practices
- Test ingress, monitor.

#### Sample spoken answer
"kubectl describe ingress. Check rules. Logs."

</details>

## Docker

<details><summary>Docker Build Fails</summary>

#### Scenario
Build succeeds locally, fails in CI.

#### Interview question
"Troubleshoot Docker build failure."

#### What interviewer evaluates
Dockerfile, context.

#### Troubleshooting approach
- Check Dockerfile
- Build context
- Base image

#### Commands / tools
docker build --no-cache

#### Root cause possibilities
- Platform differences, cache.

#### Prevention / best practices
- Consistent environments.

#### Sample spoken answer
"Build with --no-cache. Check Dockerfile."

</details>

<details><summary>Containers Can't Communicate</summary>

#### Scenario
Containers in network can't reach each other.

#### Interview question
"Troubleshoot Docker network issues."

#### What interviewer evaluates
Docker networking.

#### Troubleshooting approach
- Check network
- DNS
- Firewall

#### Commands / tools
docker network ls, docker exec ping

#### Root cause possibilities
- Network config, DNS.

#### Prevention / best practices
- Use user-defined networks.

#### Sample spoken answer
"docker network inspect. Test ping."

</details>

<details><summary>Volume Data Lost</summary>

#### Scenario
Container restart loses data.

#### Interview question
"Why is Docker volume data lost?"

#### What interviewer evaluates
Volume mounting.

#### Troubleshooting approach
- Check volume mount
- Persistence

#### Commands / tools
docker inspect, ls volume

#### Root cause possibilities
- Not using volumes, bind mount wrong.

#### Prevention / best practices
- Use named volumes.

#### Sample spoken answer
"Check if volume is mounted. Use docker volume ls."

</details>

<details><summary>Compose Services Not Starting</summary>

#### Scenario
Docker Compose up fails.

#### Interview question
"Troubleshoot Compose startup."

#### What interviewer evaluates
Compose file.

#### Troubleshooting approach
- Check compose.yml
- Dependencies
- Logs

#### Commands / tools
docker-compose logs

#### Root cause possibilities
- Config errors, depends_on.

#### Prevention / best practices
- Validate compose file.

#### Sample spoken answer
"docker-compose config. Check logs."

</details>

## Terraform

<details><summary>Unexpected Changes in Plan</summary>

#### Scenario
Terraform plan shows changes not expected.

#### Interview question
"Why does Terraform plan show unexpected changes?"

#### What interviewer evaluates
State management, config.

#### Troubleshooting approach
- Check state file
- Config changes
- Imports

#### Commands / tools
terraform plan, terraform state list

#### Root cause possibilities
- Manual changes, state drift.

#### Prevention / best practices
- No manual changes, drift detection.

#### Sample spoken answer
"Check terraform state. See if resources changed outside Terraform."

</details>

<details><summary>Dependency Issues</summary>

#### Scenario
Resources not created in order.

#### Interview question
"Troubleshoot Terraform dependencies."

#### What interviewer evaluates
Resource dependencies.

#### Troubleshooting approach
- Use depends_on
- Implicit dependencies

#### Commands / tools
terraform graph

#### Root cause possibilities
- Missing depends_on.

#### Prevention / best practices
- Proper dependencies.

#### Sample spoken answer
"Use terraform graph. Add depends_on."

</details>

<details><summary>State Lock Errors</summary>

#### Scenario
State locked, can't apply.

#### Interview question
"Handle Terraform state lock."

#### What interviewer evaluates
State locking.

#### Troubleshooting approach
- Check who locked
- Force unlock if needed

#### Commands / tools
terraform force-unlock

#### Root cause possibilities
- Concurrent runs, crashed process.

#### Prevention / best practices
- Short plans, proper locking.

#### Sample spoken answer
"Check terraform lock info. Force unlock if safe."

</details>

<details><summary>Authentication Failures</summary>

#### Scenario
Terraform can't authenticate to provider.

#### Interview question
"Troubleshoot Terraform auth issues."

#### What interviewer evaluates
Provider config.

#### Troubleshooting approach
- Check credentials
- Provider block

#### Commands / tools
terraform init

#### Root cause possibilities
- Wrong creds, env vars.

#### Prevention / best practices
- Secure creds, test init.

#### Sample spoken answer
"Check AWS creds. terraform init."

</details>

<details><summary>Module Output Issues</summary>

#### Scenario
Module outputs not available.

#### Interview question
"Why are module outputs missing?"

#### What interviewer evaluates
Module outputs.

#### Troubleshooting approach
- Check output blocks
- Module calls

#### Commands / tools
terraform output

#### Root cause possibilities
- Not defined, sensitive.

#### Prevention / best practices
- Define outputs properly.

#### Sample spoken answer
"Check module output blocks. terraform output."

</details>

## Git

<details><summary>Merge Conflicts</summary>

#### Scenario
Merge pull request has conflicts.

#### Interview question
"How do you resolve Git merge conflicts?"

#### What interviewer evaluates
Git workflow, conflict resolution.

#### Troubleshooting approach
- Identify conflicting files
- Edit and resolve
- Commit

#### Commands / tools
git status, git diff, git add, git commit

#### Root cause possibilities
- Changes to same lines.

#### Prevention / best practices
- Small PRs, rebase.

#### Sample spoken answer
"git status to see conflicts. Edit files, git add, commit."

</details>

<details><summary>Lost Commits</summary>

#### Scenario
Commits disappeared after rebase.

#### Interview question
"Recover lost Git commits."

#### What interviewer evaluates
Git reflog.

#### Troubleshooting approach
- Use git reflog
- Reset to commit

#### Commands / tools
git reflog, git reset

#### Root cause possibilities
- Force push, rebase.

#### Prevention / best practices
- Don't force push, backup.

#### Sample spoken answer
"git reflog to find commit. git reset --hard <commit>."

</details>

<details><summary>Repository Corruption</summary>

#### Scenario
Git repo corrupted.

#### Interview question
"Fix Git repository corruption."

#### What interviewer evaluates
Git maintenance.

#### Troubleshooting approach
- git fsck
- Clone fresh
- Restore from backup

#### Commands / tools
git fsck, git gc

#### Root cause possibilities
- Disk issues, interrupted operations.

#### Prevention / best practices
- Regular backups, fsck.

#### Sample spoken answer
"git fsck to check. Clone from remote if needed."

</details>

<details><summary>Diverged Branches</summary>

#### Scenario
Local and remote branches diverged.

#### Interview question
"Handle diverged Git branches."

#### What interviewer evaluates
Sync strategies.

#### Troubleshooting approach
- Fetch and merge/rebase
- Resolve conflicts

#### Commands / tools
git fetch, git merge, git rebase

#### Root cause possibilities
- Concurrent changes.

#### Prevention / best practices
- Pull before push.

#### Sample spoken answer
"git fetch. git rebase or merge."

</details>

<details><summary>Large Files in Repo</summary>

#### Scenario
Repo too large due to big files.

#### Interview question
"Remove large files from Git history."

#### What interviewer evaluates
Git LFS, history rewriting.

#### Troubleshooting approach
- Use git lfs
- git filter-branch

#### Commands / tools
git lfs, git filter-branch

#### Root cause possibilities
- Committed large files.

#### Prevention / best practices
- Use LFS for large files.

#### Sample spoken answer
"Use git lfs migrate. Or filter-branch to remove."

</details>

## Jenkins

<details><summary>Flaky Pipelines</summary>

#### Scenario
Pipeline fails intermittently.

#### Interview question
"Troubleshoot flaky Jenkins pipelines."

#### What interviewer evaluates
Stability, debugging.

#### Troubleshooting approach
- Check logs
- Isolate steps
- Environment issues

#### Commands / tools
Jenkins logs, rerun

#### Root cause possibilities
- Network, resource contention.

#### Prevention / best practices
- Retry mechanisms, stable env.

#### Sample spoken answer
"Check build logs. Rerun to see if consistent. Fix env."

</details>

<details><summary>Queue Backup</summary>

#### Scenario
Jobs queuing up.

#### Interview question
"Why are Jenkins jobs queuing?"

#### What interviewer evaluates
Resource management.

#### Troubleshooting approach
- Check executors
- Node availability
- Load

#### Commands / tools
Jenkins dashboard

#### Root cause possibilities
- Not enough nodes, stuck jobs.

#### Prevention / best practices
- Scale nodes, monitor.

#### Sample spoken answer
"Check executor status. Add more nodes."

</details>

<details><summary>Plugin Issues</summary>

#### Scenario
Plugin causing failures.

#### Interview question
"Troubleshoot Jenkins plugin problems."

#### What interviewer evaluates
Plugin management.

#### Troubleshooting approach
- Update plugins
- Check compatibility
- Disable faulty

#### Commands / tools
Jenkins plugin manager

#### Root cause possibilities
- Outdated, incompatible.

#### Prevention / best practices
- Keep updated, test upgrades.

#### Sample spoken answer
"Check plugin versions. Update or disable."

</details>

<details><summary>Security Vulnerabilities</summary>

#### Scenario
Jenkins exposed to security issues.

#### Interview question
"Secure Jenkins instance."

#### What interviewer evaluates
Security best practices.

#### Troubleshooting approach
- Update Jenkins
- Use security plugins
- Access control

#### Commands / tools
Jenkins security settings

#### Root cause possibilities
- Default config, old version.

#### Prevention / best practices
- Regular updates, least privilege.

#### Sample spoken answer
"Update to latest. Enable security. Use Matrix auth."

</details>

<details><summary>Distributed Builds Slow</summary>

#### Scenario
Distributed builds slow.

#### Interview question
"Optimize Jenkins distributed builds."

#### What interviewer evaluates
Performance tuning.

#### Troubleshooting approach
- Check network
- Node resources
- Pipeline efficiency

#### Commands / tools
Jenkins metrics

#### Root cause possibilities
- Slow network, underpowered nodes.

#### Prevention / best practices
- Fast network, sufficient resources.

#### Sample spoken answer
"Check node performance. Optimize pipelines."

</details>

## Monitoring

<details><summary>Missing Metrics</summary>

#### Scenario
Metrics not collected.

#### Interview question
"Why are metrics missing?"

#### What interviewer evaluates
Metrics collection.

#### Troubleshooting approach
- Check exporters
- Scraping config
- Targets

#### Commands / tools
Prometheus targets

#### Root cause possibilities
- Down exporters, config.

#### Prevention / best practices
- Health checks.

#### Sample spoken answer
"Check Prometheus targets. Restart exporters."

</details>

<details><summary>Alert Fatigue</summary>

#### Scenario
Too many alerts, ignored.

#### Interview question
"Manage alert fatigue."

#### What interviewer evaluates
Alert management.

#### Troubleshooting approach
- Group alerts
- Prioritize
- Auto-resolve

#### Commands / tools
Alertmanager

#### Root cause possibilities
- Too many rules.

#### Prevention / best practices
- Smart routing, silencing.

#### Sample spoken answer
"Use Alertmanager grouping. Silence known issues."

</details>

<details><summary>Performance Issues Not Detected</summary>

#### Scenario
System slow but no alerts.

#### Interview question
"Why weren't performance issues detected?"

#### What interviewer evaluates
Monitoring coverage.

#### Troubleshooting approach
- Check metrics
- Thresholds
- Dashboards

#### Commands / tools
Grafana dashboards

#### Root cause possibilities
- Missing metrics, wrong thresholds.

#### Prevention / best practices
- Comprehensive monitoring.

#### Sample spoken answer
"Add more metrics. Adjust thresholds."

</details>