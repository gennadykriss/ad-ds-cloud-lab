# 01 — VM Setup & Network Configuration

## Virtual machines

Two VMs on the **same VMware network segment** (both NAT or both Host-only) so they can reach each other:

| VM | Role | OS |
|----|------|-----|
| DC01 | Domain controller + DNS | Windows Server 2022 Standard (Core) |
| CLIENT01 | Domain member | Windows 10/11 or Server |

> **Note on installation:** VMware *Easy Install* failed with a "cannot find the Microsoft Software License Terms" error. The fix was to create the VM with *"I will install the operating system later,"* attach the ISO under **VM Settings → CD/DVD → Use ISO image file** (Connect at power on), and run a manual install. The install produced **Server Core** (no GUI), which this lab embraces and drives entirely from the CLI.

## First boot — SConfig

Server Core boots to **SConfig**, a text menu. Useful options here:

- `2) Computer name` → rename to `DC01`, reboot when prompted
- `8) Network settings` → set static IP (or use PowerShell below)
- `15) Exit to command line (PowerShell)` → drop to a shell

## Static IP (PowerShell)

A domain controller needs a fixed address. From `15) Exit to command line`:

```powershell
# Identify the adapter
Get-NetIPInterface
Get-NetAdapter

# Set a static address (adjust InterfaceIndex, IP, gateway to your subnet)
New-NetIPAddress -InterfaceIndex 4 -IPAddress 10.0.0.4 -PrefixLength 24 -DefaultGateway 10.0.0.1

# A DC resolves DNS against itself
Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses 127.0.0.1

# Confirm
Get-NetIPConfiguration
```

See [`scripts/01-configure-network.ps1`](../scripts/01-configure-network.ps1).
