<#
.SYNOPSIS
    Creates sample domain user accounts.
.NOTES
    Run on DC01 after promotion.
    Passwords here are NON-SECRET PLACEHOLDERS — change them before use
    and never commit real credentials to source control.
#>

# Single user with an interactive (hidden) password prompt
New-ADUser -Name "Jane Doe" -SamAccountName "jdoe" `
  -UserPrincipalName "jdoe@corp.lab.local" `
  -AccountPassword (Read-Host -AsSecureString "Password") `
  -Enabled $true -ChangePasswordAtLogon $true

# Bulk create from a list
$users = "asmith","bwong","clee"
foreach ($u in $users) {
  New-ADUser -Name $u -SamAccountName $u `
    -UserPrincipalName "$u@corp.lab.local" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
    -Enabled $true -ChangePasswordAtLogon $true
}

# Confirm
Get-ADUser -Filter * | Select-Object Name,SamAccountName,Enabled
