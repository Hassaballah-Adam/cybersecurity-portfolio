# Week 3 Notes: Python for Security

Adam, H. (2026). *Week 3 lab reflections: Python scripting for security automation and network enumeration* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 7: Security Scripting & Service Enumeration

`security_audit.py` was developed to automate local security checks: open port scanning via TCP socket connections, SUID file detection, world-writable file enumeration, and user account auditing. Python's `socket` module enables low-level TCP connection attempts without requiring external tools, making it suitable for environments where Nmap may not be available (Seitz, 2021). The script outputs structured results for downstream analysis.

**Key concepts:** Python `socket` module, TCP connect scanning, `os.stat()` permission checking, subprocess integration, audit automation.

## Session 8: System Interrogation with Python

`system_interrogation.py` leverages the `platform`, `subprocess`, and `os` modules to capture system state: disk usage, memory information, network interfaces, and logged-in users. Results are appended to `/var/log/sys_audit.log` with timestamps, establishing a lightweight audit trail. Automated system interrogation is a foundational capability for both security monitoring and incident response triage (NIST, 2012).

**Key concepts:** `platform` module, `subprocess.run()`, log file appending, timestamped audit entries, system state capture.

## Session 9: Network Scripting & TCP Port Connection

`tcp_connect.py` implements a configurable TCP connect scanner with banner grabbing capability. The script resolves hostnames, iterates through specified ports, and captures service banners where available. Banner grabbing assists in service fingerprinting without requiring Nmap's version detection engine. Argparse integration makes the tool flexible for different scan scenarios (Seitz, 2021).

**Key concepts:** TCP connect scanning, banner grabbing, argparse CLI design, hostname resolution, service fingerprinting.

## References

National Institute of Standards and Technology. (2012). *Guide to computer security log management* (NIST SP 800-92). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-92

Seitz, J. (2021). *Black hat Python: Python programming for hackers and pentesters* (2nd ed.). No Starch Press.
