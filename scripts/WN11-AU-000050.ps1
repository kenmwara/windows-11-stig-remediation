<#
.SYNOPSIS
    Turns on auditing of process creation (Detailed Tracking > Process Creation, Success), so Windows writes
    event 4688 every time a process starts: the same parent -> child evidence used in the SecOps 2 telemetry
    labs (DeviceProcessEvents) and the SecOps 5 hunt (wmiprvse.exe -> cmd.exe -> the implant).

.NOTES
    Author          : Ken Kariuki
    LinkedIn        : linkedin.com/in/kenmwara
    GitHub          : github.com/kenmwara
    Date Created    : 2026-09-27
    Last Modified   : 2026-09-27
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A (Tenable compliance audit: DISA Microsoft Windows 11 STIG v2r9)
    STIG-ID         : WN11-AU-000050

.TESTED ON
    Date(s) Tested  : 2026-09-27
    Tested By       : Ken Kariuki
    Systems Tested  : kk-mde-win11 (Windows 11 Pro 25H2, Azure, Cyber Range 4)
    PowerShell Ver. : 5.1

.USAGE
    Run in an elevated (Administrator) PowerShell on the VM:
    PS C:\> .\WN11-AU-000050.ps1
    Then rescan with Tenable ("kk-mde-win11 DISA STIG scan (Win 11)") and confirm WN11-AU-000050 shows Passed.
#>

# The GUID is the "Process Creation" subcategory; it works on any Windows display language.
$subcategory = '{0CCE922B-69AE-11D9-BED3-505054503030}'

auditpol /set /subcategory:$subcategory /success:enable

# Show the result: expect "Process Creation    Success" (or "Success and Failure").
auditpol /get /subcategory:$subcategory
