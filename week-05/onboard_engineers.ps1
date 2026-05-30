# S13 Lab: Security Policy Design, IAM & MFA — Engineer Onboarding
# Analyst: Hassaballah Adam
# Date: 2026-02-10

# Import Active Directory module
Import-Module ActiveDirectory

# Define new engineer accounts
$engineers = @(
    @{ Name = "Alice Chen";    SAM = "achen";   Department = "Security Engineering" },
    @{ Name = "Bob Okafor";    SAM = "bokafor"; Department = "Security Engineering" },
    @{ Name = "Clara Reyes";   SAM = "creyes";  Department = "SOC Operations" }
)

$OUPath = "OU=Engineers,OU=Staff,DC=titan,DC=local"
$DefaultPassword = ConvertTo-SecureString "Titan@2026!" -AsPlainText -Force

foreach ($eng in $engineers) {
    try {
        New-ADUser `
            -Name $eng.Name `
            -SamAccountName $eng.SAM `
            -UserPrincipalName "$($eng.SAM)@titan.local" `
            -Path $OUPath `
            -AccountPassword $DefaultPassword `
            -Department $eng.Department `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -PasswordNeverExpires $false

        # Add to Security Engineers group
        Add-ADGroupMember -Identity "Security-Engineers" -Members $eng.SAM

        # Enable MFA flag (Azure AD hybrid — requires MFA server or Azure MFA)
        Set-ADUser -Identity $eng.SAM -Add @{
            'msDS-cloudExtensionAttribute1' = 'MFARequired'
        }

        Write-Host "[+] Created user: $($eng.SAM) in $OUPath"
    }
    catch {
        Write-Host "[!] Error creating $($eng.SAM): $_"
    }
}

Write-Host "`n[+] Onboarding complete. Users must change password on first login."
Write-Host "[+] MFA enrollment required within 24 hours."
