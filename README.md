<!-- banner --><a href="https://github.com/kenmwara"><img src="https://raw.githubusercontent.com/kenmwara/kenmwara/main/assets/brand/card-stig.png?v=1c210d14f2" width="100%" alt="Windows 11 STIG: Ten DISA STIG findings on a Windows 11 lab VM, each remediated with PowerShell and verified by a credentialed compliance scan. 10/10 failed → passed."></a>

# Windows 11 STIG remediation

**Ten security settings on a Windows 11 computer, fixed and proven: each one failed the official US government
checklist before, and passed after.**

The checklist is the DISA STIG for Windows 11, the security standard the US Department of Defense uses for its
computers. Each setting was fixed with a PowerShell script and confirmed by a Tenable scan that logs in and checks the
computer against the checklist.

- **Checklist:** DISA Microsoft Windows 11 STIG v2r9, run as a Tenable compliance scan.
- **Target:** one Windows 11 Pro 25H2 virtual machine in Azure, part of the LOG(N) Pacific Cyber Range.
- **Before:** 258 checks, 142 failed, 11 warnings, 105 passed (27 Sep 2026, 12:15 PM PT).
- **After:** 131 failed, 11 warnings, 116 passed. All ten targeted settings pass.

## At a glance

<img src="images/flow.png" width="100%" alt="Flow diagram: how each failed setting was fixed and proven. Start: run the DISA Windows 11 STIG audit as a scan that logs in: 258 checks, 142 failed (the scan needs the firewall opened, Remote Registry on and remote UAC relaxed, all put back afterwards). Take the next failed finding; ten were chosen (the host-firewall finding kept failing with Windows' own tools, so it was swapped). Write one PowerShell script that sets exactly that setting and prints the value back, run it as Administrator, rescan. Did the finding move from Failed to Passed? No: fix the script (the first security-log fix of 1,024,000 KB failed; the scan needed 5,120,000). Yes: any of the ten still to fix? Yes: next finding. No: end, 10 of 10 failed to passed; failed checks 142 to 131, passed 105 to 116.">

<sub>Editable diagram: [images/flow.drawio](images/flow.drawio) (opens in diagrams.net).</sub>

## The ten settings

<img src="images/the-ten.png" width="100%" alt="Ten settings that failed the checklist, each fixed and passed. Each one was fixed with a PowerShell script, then a Tenable scan logged in and checked it again. All ten moved from Failed to Passed. Record every program started: Windows logs each program that runs. Proof: Failed before; passed on the rescan Detailed audit rules win: The fine-grained logging rules override the broad ones. Proof: Failed before; passed on the rescan Bigger app log: The application log holds at least 32 MB. Proof: Failed before; passed on the rescan Bigger security log: The security log keeps a week of records (5 GB in this scan). Proof: Failed before; passed on the rescan Bigger system log: The system log holds at least 32 MB. Proof: Failed before; passed on the rescan Memory attack protection: A Windows defence against a common crash-and-hijack trick (SEHOP) is on. Proof: Failed before; passed on the rescan No 'run as someone else': The Secondary Logon service is switched off. Proof: Failed before; passed on the rescan No camera on the lock screen: The camera can't be used before signing in. Proof: Failed before; passed on the rescan No passwords kept in memory: WDigest, an old login method that leaves passwords readable, is off. Proof: Failed before; passed on the rescan Record every PowerShell script: The full text of each script that runs is logged. Proof: Failed before; passed on the rescan">

<details><summary>The ten as a table, with checklist IDs and scripts</summary>

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

</details>

## Method

1. Run the DISA Windows 11 STIG audit as a credentialed scan and record every failed check.
2. For each finding, write one PowerShell script that sets exactly the setting the STIG checks, then prints the value
   back as evidence.
3. Run the script as Administrator on the VM.
4. Rescan with the same scan and confirm the finding moved from Failed to Passed.

## Lessons learned

- **A scanner's check can be stricter than the STIG text.** WN11-AU-000505 asks for a Security log that holds "one
  week" of records; the Tenable audit enforces at least 5120000 KB. The first fix (1024000 KB) failed the rescan.
- **Some findings can't pass with built-in tooling.** WN11-00-000135 (host-based firewall) kept failing with all
  three Windows Defender Firewall profiles on, so it was replaced rather than forced.
- **Credentialed scanning of a standalone Windows 11 VM** needs the scanner allowed through the firewall, Remote
  Registry available, and remote UAC filtering relaxed for the local admin account during the scan. All of it was
  put back afterwards.
- **Audit settings are the evidence trail.** Process Creation auditing (event 4688) and script block logging (event 4104)
  record exactly the evidence a threat hunt depends on.

## Using the scripts

Each script is standalone. Run it in an elevated PowerShell on the target, then rescan. The scripts only set the one
value their STIG checks; review them before running anywhere that is not a lab.

---

Ken Kariuki · [github.com/kenmwara](https://github.com/kenmwara) · [linkedin.com/in/kenmwara](https://linkedin.com/in/kenmwara)
