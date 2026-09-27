<#
.SYNOPSIS
    Disables WDigest authentication, which otherwise keeps plain-text passwords in LSASS memory where tools like
    Mimikatz can dump them (credential theft, the same stage as the SecOps 5 hunt's password spray and admin takeover).

.NOTES
    Author          : Ken Kariuki
    LinkedIn        : linkedin.com/in/kenmwara
    GitHub          : github.com/kenmwara
    Date Created    : 2026-09-27
    Last Modified   : 2026-09-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A (Tenable compliance audit: DISA Microsoft Windows 11 STIG v2r9)
    STIG-ID         : WN11-CC-000038

.TESTED ON
    Date(s) Tested  : 2026-09-27
    Tested By       : Ken Kariuki
    Systems Tested  : kk-mde-win11 (Windows 11 Pro 25H2, Azure, Cyber Range 4)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated (Administrator) PowerShell on the VM:
    PS C:\> .\WN11-CC-000038.ps1
    Then rescan with Tenable ("kk-mde-win11 DISA STIG scan (Win 11)") and confirm WN11-CC-000038 shows Passed.
#>

$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest'

# Create the key if this VM doesn't have it yet.
if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
New-ItemProperty -Path $path -Name 'UseLogonCredential' -Value 0 -PropertyType DWord -Force | Out-Null

# Show the result: expect UseLogonCredential = 0.
Get-ItemProperty -Path $path -Name 'UseLogonCredential' | Select-Object UseLogonCredential
