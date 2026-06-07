# Active Directory Domain Services — Cloud/Virtualized Lab

Deployed Active Directory Domain Services (AD DS) on **Windows Server 2022 Core**, configured entirely through the **PowerShell CLI**. Built a new forest, joined a client workstation to the domain, and provisioned user accounts — no graphical management tools used on the server.

## Objective

1. Create two virtual machines — one domain controller, one client
2. Configure Active Directory Domain Services
3. Create a new forest
4. Join the client computer to the domain
5. Create user accounts
6. Verify the deployment end to end

## Architecture

```
            corp.lab.local  (forest / domain)
        ┌──────────────────────────────────────┐
        │                                        │
   ┌────┴─────┐                          ┌──────┴──────┐
   │  DC01    │   <───  DNS / LDAP  ───>  │  CLIENT01   │
   │ 10.0.0.4 │        Kerberos           │  (DHCP)     │
   │  DC+DNS  │                           │  domain mbr │
   └──────────┘                           └─────────────┘
   Server 2022 Core                       Win 10/11 or Server
```

| Host | Role | OS | Address |
|------|------|-----|---------|
| DC01 | Domain controller + DNS | Windows Server 2022 Standard (Core) | 10.0.0.4 (static) |
| CLIENT01 | Domain member | Windows 10/11 or Server | DHCP, DNS → 10.0.0.4 |

- **Domain:** `corp.lab.local`
- **NetBIOS:** `CORP`
- **Functional level:** WinThreshold (Server 2016)

## Environment / Stack

- VMware Workstation (NAT or Host-only segment shared by both VMs)
- Windows Server 2022 Standard — **Core** edition (managed via SConfig + PowerShell)
- Windows Active Directory Domain Services + integrated DNS
- PowerShell 5.1

## Walkthrough

The lab is documented in phases under [`/docs`](docs/), with the matching automation scripts under [`/scripts`](scripts/):

1. [VM setup & network configuration](docs/01-vm-setup.md)
2. [Domain controller promotion](docs/02-domain-controller.md)
3. [Client domain join](docs/03-client-join.md)
4. [Verification](docs/04-verification.md)

## Verification

Confirmed working via:

- `Get-ADDomain` / `Get-ADForest` — forest and domain online
- `Get-ADUser -Filter *` — provisioned accounts present
- `Get-ADComputer -Filter *` — CLIENT01 computer object created on join
- Interactive login to CLIENT01 as a domain user (`CORP\jdoe`)

See [04-verification.md](docs/04-verification.md) for full output.

## Challenges & Lessons Learned

- **VMware Easy Install failed** with a "cannot find the Microsoft Software License Terms" error. Resolved by disabling Easy Install and performing a manual install from the ISO.
- **Landed on Server Core** (no desktop GUI) instead of Desktop Experience. Rather than reinstall, chose to complete the entire lab through the CLI — closer to real-world server administration and good PowerShell practice. Server 2022 does not support adding the GUI to Core after install, so this was a deliberate commitment to the CLI path.
- **Client DNS is the critical step** — a domain member must use the DC as its DNS server or domain discovery (`nltest /dsgetdc`) fails. Both VMs also must share the same VMware network segment to communicate.

## Notes

This is a closed lab using RFC 1918 addressing (`10.0.0.x`) and a private domain (`corp.lab.local`). All credentials shown in scripts and docs are **non-secret placeholder examples** — replace them with your own and never commit real passwords.

## License

MIT — see [LICENSE](LICENSE).
