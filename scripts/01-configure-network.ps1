<#
.SYNOPSIS
    Configures a static IP and self-referential DNS on DC01.
.NOTES
    Run on the future domain controller (Server Core) before promotion.
    Adjust InterfaceIndex, IP, prefix, and gateway to match your subnet.
#>

# Inspect adapters to find the correct InterfaceIndex
Get-NetIPInterface
Get-NetAdapter

# --- Adjust these to your environment ---
$IfIndex = 4
$IPAddress = "10.0.0.4"
$Prefix    = 24
$Gateway   = "10.0.0.1"
# -----------------------------------------

New-NetIPAddress -InterfaceIndex $IfIndex -IPAddress $IPAddress -PrefixLength $Prefix -DefaultGateway $Gateway

# A domain controller points DNS at itself
Set-DnsClientServerAddress -InterfaceIndex $IfIndex -ServerAddresses 127.0.0.1

Get-NetIPConfiguration
