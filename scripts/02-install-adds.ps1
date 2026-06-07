<#
.SYNOPSIS
    Installs AD DS and promotes DC01 to the first DC in a new forest.
.NOTES
    Run on DC01 after the static IP is configured.
    Prompts for a DSRM password; the server reboots automatically on completion.
#>

# Install the AD DS role + management tools
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

# Promote to first DC in a new forest
Install-ADDSForest `
  -DomainName "corp.lab.local" `
  -DomainNetbiosName "CORP" `
  -ForestMode "WinThreshold" `
  -DomainMode "WinThreshold" `
  -InstallDns:$true `
  -Force
