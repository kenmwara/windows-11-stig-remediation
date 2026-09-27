<#
.SYNOPSIS
    Sets the maximum size of the Windows System event log to 32768 KB (32 MB) or greater, so service, driver and
    system events are not overwritten before they can be collected and reviewed.

.NOTES
    Author          : Ken Kariuki
    LinkedIn        : linkedin.com/in/kenmwara
    GitHub          : github.com/kenmwara
    Date Created    : 2026-09-27
    Last Modified   : 2026-09-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A (Tenable compliance audit: DISA Microsoft Windows 11 STIG v2r9)
    STIG-ID         : WN11-AU-000510

.TESTED ON
    Date(s) Tested  : 2026-09-27
    Tested By       : Ken Kariuki
    Systems Tested  : kk-mde-win11 (Windows 11 Pro 25H2, Azure, Cyber Range 4)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated (Administrator) PowerShell on the VM:
    PS C:\> .\WN11-AU-000510.ps1
    Then rescan with Tenable ("kk-mde-win11 DISA STIG scan (Win 11)") and confirm WN11-AU-000510 shows Passed.
#>

$path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System'

# The policy key does not exist on a fresh VM, so create it first.
if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
New-ItemProperty -Path $path -Name 'MaxSize' -Value 32768 -PropertyType DWord -Force | Out-Null

# Show the result: expect MaxSize = 32768.
Get-ItemProperty -Path $path -Name 'MaxSize' | Select-Object MaxSize
