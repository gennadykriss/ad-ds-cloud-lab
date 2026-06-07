<#
.SYNOPSIS
    Points CLIENT01 at the DC for DNS and joins it to the domain.
.NOTES
    Run on CLIENT01 (admin PowerShell). The client reboots on join.
#>

# Confirm the adapter name (adjust -InterfaceAlias below if different)
Get-NetAdapter

# Point DNS at the domain controller — REQUIRED for domain discovery
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.0.0.4

# Sanity checks
Resolve-DnsName corp.lab.local      # expect 10.0.0.4
Test-Connection 10.0.0.4 -Count 2   # both VMs must share a VMware segment

# Join the domain (prompts for CORP\Administrator credentials), then reboot
Add-Computer -DomainName "corp.lab.local" -Credential (Get-Credential) -Restart
