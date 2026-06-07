# 02 — Domain Controller Promotion

Run on **DC01** (PowerShell, after the static IP is set).

## Install the AD DS role

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

## Promote to the first DC in a new forest

```powershell
Import-Module ADDSDeployment

Install-ADDSForest `
  -DomainName "corp.lab.local" `
  -DomainNetbiosName "CORP" `
  -ForestMode "WinThreshold" `
  -DomainMode "WinThreshold" `
  -InstallDns:$true `
  -Force
```

- Prompts for a **DSRM (Directory Services Restore Mode) password** — record it.
- `-InstallDns` stands up DNS on the DC (required for AD).
- The VM **reboots automatically** when promotion completes.
- After reboot, log in as `CORP\Administrator`.

See [`scripts/02-install-adds.ps1`](../scripts/02-install-adds.ps1).

## Create users

```powershell
# Single user (interactive password)
New-ADUser -Name "Jane Doe" -SamAccountName "jdoe" `
  -UserPrincipalName "jdoe@corp.lab.local" `
  -AccountPassword (Read-Host -AsSecureString "Password") `
  -Enabled $true -ChangePasswordAtLogon $true

# Several at once
$users = "asmith","bwong","clee"
foreach ($u in $users) {
  New-ADUser -Name $u -SamAccountName $u `
    -UserPrincipalName "$u@corp.lab.local" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -Enabled $true -ChangePasswordAtLogon $true
}
```

See [`scripts/03-create-users.ps1`](../scripts/03-create-users.ps1).
