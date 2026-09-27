<#
.SYNOPSIS
    Turns on PowerShell script block logging (event 4104), so the full text of every PowerShell script that runs is
    recorded: the telemetry a threat hunter needs when an attacker lives off the land with PowerShell.

.NOTES
    Author          : Ken Kariuki
    LinkedIn        : linkedin.com/in/kenmwara
    GitHub          : github.com/kenmwara
    Date Created    : 2026-09-27
    Last Modified   : 2026-09-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A (Tenable compliance audit: DISA Microsoft Windows 11 STIG v2r9)
    STIG-ID         : WN11-CC-000326

.TESTED ON
    Date(s) Tested  : 2026-09-27
    Tested By       : Ken Kariuki
    Systems Tested  : kk-mde-win11 (Windows 11 Pro 25H2, Azure, Cyber Range 4)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated (Administrator) PowerShell on the VM:
    PS C:\> .\WN11-CC-000326.ps1
    Then rescan with Tenable ("kk-mde-win11 DISA STIG scan (Win 11)") and confirm WN11-CC-000326 shows Passed.
#>

$path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'

# Create the key if this VM doesn't have it yet.
if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
New-ItemProperty -Path $path -Name 'EnableScriptBlockLogging' -Value 1 -PropertyType DWord -Force | Out-Null

# Show the result: expect EnableScriptBlockLogging = 1.
Get-ItemProperty -Path $path -Name 'EnableScriptBlockLogging' | Select-Object EnableScriptBlockLogging
