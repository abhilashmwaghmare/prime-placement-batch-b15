# Linux: Server Reachable, Port Closed Suddenly

## Scenario
EC2 is pingable, SSH works, but port 443 is closed. Users see connection refused.

## Interview question
"How do you troubleshoot service down vs network issue?"

## What interviewer evaluates
Service checks, port checks, logs, firewall.

## Troubleshooting approach
- Verify service status
- Verify process listening on port
- Check local firewall
- Check app logs

## Commands / tools
```
systemctl status nginx
ss -tulnp | grep 443
curl -vk https://localhost
journalctl -u nginx -n 100
iptables -L -n
```

## Root cause possibilities
- Service crash, config error, cert expiry, port conflict, deploy broke service.

## Prevention / best practices
- Health checks, canary deploy, config tests, auto-restart, cert monitoring.

## Sample spoken answer
"I'll start by checking if the service is running and listening on 443 using systemctl and ss. Then I'll curl locally to separate app vs network. If service is down, I'll read logs and fix config/cert issues, then restart. After recovery, I'll add deployment validation and alerts on port health and certificate expiry."