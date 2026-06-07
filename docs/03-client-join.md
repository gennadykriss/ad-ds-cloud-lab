# 03 — Client Domain Join

Run on **CLIENT01** (admin PowerShell).

## Point the client at the DC for DNS

This is the step most labs get wrong. A domain member **must** use the DC as its DNS server, or it cannot locate the domain.

```powershell
# Check the adapter name first
Get-NetAdapter

# Point DNS at DC01
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.0.0.4

# Verify resolution and connectivity
Resolve-DnsName corp.lab.local      # should return 10.0.0.4
Test-Connection 10.0.0.4            # both VMs must share the same VMware segment
```

## Join the domain

```powershell
Add-Computer -DomainName "corp.lab.local" -Credential (Get-Credential) -Restart
```

- Enter `CORP\Administrator` and password at the prompt.
- The client **reboots** to complete the join.
- After reboot, log in as a domain user, e.g. `CORP\jdoe`.

See [`scripts/04-join-domain.ps1`](../scripts/04-join-domain.ps1).

## Troubleshooting

| Symptom | Likely cause |
|---------|--------------|
| "domain could not be found" | Client DNS not pointed at DC01 |
| Cannot ping 10.0.0.4 | VMs on different VMware segments / firewall |
| Credential rejected | Use `CORP\Administrator`, not local admin |
