# Week 5 Notes: Identity, Access & Active Directory

Adam, H. (2026). *Week 5 lab reflections: IAM policy design, Group Policy enforcement, and Linux-Windows identity unification* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 13: Security Policy Design, IAM & MFA

`onboard_engineers.ps1` automates engineer account provisioning in Active Directory using PowerShell's `ActiveDirectory` module. Accounts are created with `ChangePasswordAtLogon $true`, enforcing password rotation on first login. MFA enrollment is flagged via a custom AD attribute, supporting hybrid Azure AD MFA enforcement. Automating IAM provisioning reduces human error and ensures policy-compliant account creation (Microsoft, 2023).

**Key concepts:** PowerShell AD module, `New-ADUser`, group membership assignment, MFA flagging, forced password change.

## Session 14: Group Policy & Access Control Enforcement

The GPO audit identified two critical findings: workstations not receiving the Engineer Workstation Policy due to a WMI filter misconfiguration, and an ungoverned legacy OU with no audit policy. GPOs are the primary mechanism for enforcing security baselines across Windows domain environments. Ungoverned OUs represent significant compliance and detection gaps (Microsoft, 2022).

**Key concepts:** GPO linking, WMI filters, password policy baselines, LAPS, SMBv1 deprecation, audit policy enforcement.

## Session 15: Linux-Windows Domain Join & Identity Unification

`realmd` and `SSSD` were used to join an Ubuntu 22.04 server to the `titan.local` AD domain, enabling single-identity authentication across both Linux and Windows systems. The `pam_mkhomedir` module auto-creates home directories for domain users on first login. Unified identity management reduces credential sprawl and centralizes access control (Red Hat, 2022).

**Key concepts:** `realm join`, SSSD configuration, PAM integration, `/etc/krb5.conf`, domain user authentication on Linux.

## References

Microsoft. (2022). *Group Policy overview*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview

Microsoft. (2023). *Active Directory Domain Services overview*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview

Red Hat. (2022). *Integrating Linux systems with Active Directory*. Red Hat Documentation. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/integrating_rhel_systems_directly_with_windows_active_directory/
