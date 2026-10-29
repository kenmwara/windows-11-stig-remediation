<!-- banner --><a href="https://github.com/kenmwara"><img src="https://raw.githubusercontent.com/kenmwara/kenmwara/main/assets/brand/card-stig.png?v=ca746e9b" width="100%" alt="Windows 11 STIG: Ten DISA STIG findings on a Windows 11 lab VM, each remediated with PowerShell and verified by a credentialed compliance scan. 10/10 failed → passed."></a>

# Windows 11 STIG remediation

Ten DISA STIG findings on a Windows 11 Pro 25H2 lab VM in Azure, each remediated with PowerShell and verified with a
credentialed Tenable compliance scan: **failed before, passed after**.

- **Benchmark:** DISA Microsoft Windows 11 STIG v2r9, run as a Tenable Vulnerability Management compliance audit inside a
  credentialed Advanced Network Scan.
- **Target:** one Azure lab VM (Windows 11 Pro 25H2), part of the LOG(N) Pacific Cyber Range.
- **Baseline:** 258 checks, 142 failed, 11 warnings, 105 passed (27 Sep 2026, 12:15 PM PT).
- **After remediation:** 131 failed, 11 warnings, 116 passed. All ten targeted findings pass.

## The ten

| STIG ID | Finding | Before | After | Script |
|---|---|---|---|---|
| WN11-AU-000050 | Audit Detailed Tracking - Process Creation (Success) | Failed | Passed | [WN11-AU-000050.ps1](scripts/WN11-AU-000050.ps1) |
| WN11-SO-000030 | Audit subcategory settings must override category settings | Failed | Passed | [WN11-SO-000030.ps1](scripts/WN11-SO-000030.ps1) |
| WN11-AU-000500 | Application event log size ≥ 32768 KB | Failed | Passed | [WN11-AU-000500.ps1](scripts/WN11-AU-000500.ps1) |
| WN11-AU-000505 | Security event log size (one week of records; 5120000 KB in this audit) | Failed | Passed | [WN11-AU-000505.ps1](scripts/WN11-AU-000505.ps1) |
| WN11-AU-000510 | System event log size ≥ 32768 KB | Failed | Passed | [WN11-AU-000510.ps1](scripts/WN11-AU-000510.ps1) |
| WN11-00-000150 | Structured Exception Handling Overwrite Protection (SEHOP) enabled | Failed | Passed | [WN11-00-000150.ps1](scripts/WN11-00-000150.ps1) |
| WN11-00-000175 | Secondary Logon service disabled | Failed | Passed | [WN11-00-000175.ps1](scripts/WN11-00-000175.ps1) |
| WN11-CC-000005 | Camera access from the lock screen disabled | Failed | Passed | [WN11-CC-000005.ps1](scripts/WN11-CC-000005.ps1) |
| WN11-CC-000038 | WDigest authentication disabled | Failed | Passed | [WN11-CC-000038.ps1](scripts/WN11-CC-000038.ps1) |
| WN11-CC-000326 | PowerShell script block logging enabled | Failed | Passed | [WN11-CC-000326.ps1](scripts/WN11-CC-000326.ps1) |

## Method

1. Run the DISA Windows 11 STIG audit as a credentialed scan and record every failed check.
2. For each finding, write one PowerShell script that sets exactly the setting the STIG checks, then prints the value
   back as evidence.
3. Run the script as Administrator on the VM.
4. Rescan with the same scan and confirm the finding moved from Failed to Passed.

## What I learned

- **A scanner's check can be stricter than the STIG text.** WN11-AU-000505 asks for a Security log that holds "one
  week" of records; the Tenable audit enforces at least 5120000 KB. The first fix (1024000 KB) failed the rescan.
- **Some findings can't pass with built-in tooling.** WN11-00-000135 (host-based firewall) kept failing with all
  three Windows Defender Firewall profiles on, so it was replaced rather than forced.
- **Credentialed scanning of a standalone Windows 11 VM** needs the scanner allowed through the firewall, Remote
  Registry available, and remote UAC filtering relaxed for the local admin account during the scan. All of it was
  put back afterwards.
- **Audit settings are telemetry.** Process Creation auditing (event 4688) and script block logging (event 4104)
  record exactly the evidence a threat hunt depends on.

## Using the scripts

Each script is standalone. Run it in an elevated PowerShell on the target, then rescan. The scripts only set the one
value their STIG checks; review them before running anywhere that is not a lab.

---

Ken Kariuki · [github.com/kenmwara](https://github.com/kenmwara) · [linkedin.com/in/kenmwara](https://linkedin.com/in/kenmwara)
