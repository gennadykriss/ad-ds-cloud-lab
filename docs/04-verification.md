# 04 — Verification

## On DC01

```powershell
# Domain & forest are online
Get-ADDomain
Get-ADForest

# Core directory services running
Get-Service ADWS,KDC,Netlogon,DNS    # all should show Running

# Locate the DC
nltest /dsgetdc:corp.lab.local

# Provisioned users exist
Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled

# Client computer object created after join
Get-ADComputer -Filter * | Select-Object Name,DNSHostName
```

## On CLIENT01 (after join + reboot)

```powershell
# Confirm domain membership
Get-ComputerInfo -Property CsDomain,CsDomainRole
# CsDomain      : corp.lab.local
# CsDomainRole  : MemberWorkstation  (or MemberServer)

# Confirm logged-in identity
whoami            # CORP\jdoe
```

## Screenshots

Recommended captures for the [`/screenshots`](../screenshots/) folder:

- `sconfig-menu.png` — Server Core SConfig menu
- `forest-promotion.png` — `Install-ADDSForest` completing
- `get-aduser.png` — user list output
- `client-joined.png` — `Get-ComputerInfo` showing `corp.lab.local`
