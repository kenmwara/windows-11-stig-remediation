<#
.SYNOPSIS
    Forces the detailed (subcategory) audit settings to override the old category-level audit policy
    ("Audit: Force audit policy subcategory settings ... to override audit policy category settings" = Enabled).
    Without it, a legacy category policy can silently switch off subcategory auditing such as Process Creation
    (WN11-AU-000050), which the SecOps 2 telemetry and SecOps 5 hunt depended on.

.NOTES
    Author          : Ken Kariuki
    LinkedIn        : linkedin.com/in/kenmwara
    GitHub          : github.com/kenmwara
    Date Created    : 2026-09-27
    Last Modified   : 2026-09-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A (Tenable compliance audit: DISA Microsoft Windows 11 STIG v2r9)
    STIG-ID         : WN11-SO-000030

.TESTED ON
    Date(s) Tested  : 2026-09-27
    Tested By       : Ken Kariuki
    Systems Tested  : kk-mde-win11 (Windows 11 Pro 25H2, Azure, Cyber Range 4)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated (Administrator) PowerShell on the VM:
    PS C:\> .\WN11-SO-000030.ps1
    Then rescan with Tenable ("kk-mde-win11 DISA STIG scan (Win 11)") and confirm WN11-SO-000030 shows Passed.
#>

$lsa = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
New-ItemProperty -Path $lsa -Name 'SCENoApplyLegacyAuditPolicy' -Value 1 -PropertyType DWord -Force | Out-Null

# Show the result: expect SCENoApplyLegacyAuditPolicy = 1.
Get-ItemProperty -Path $lsa -Name 'SCENoApplyLegacyAuditPolicy' | Select-Object SCENoApplyLegacyAuditPolicy
