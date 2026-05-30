# Week 1 Notes: Linux Fundamentals

Adam, H. (2026). *Week 1 lab reflections: Linux filesystem navigation and security automation* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 1: Filesystem Navigation & Enumeration

This session introduced the Linux filesystem hierarchy and fundamental enumeration techniques used in security contexts. Navigation commands including `pwd`, `ls -la`, and `find` were used to map directory structures and identify files of interest. The `find` command with the `-perm -4000` flag was particularly significant for locating SUID binaries, which represent potential privilege escalation vectors (Kerrisk, 2010). Output was captured to `discovery.txt` as a structured command log.

**Key concepts:** Linux filesystem hierarchy standard (FHS), SUID/SGID permissions, world-writable files, `/etc/passwd` and `/etc/shadow` structure.

## Session 2: File Permission Hardening & Security Automation

Permission hardening was applied using `chmod` and `chown` to restrict access to sensitive system files. The `harden.sh` script automates removal of unnecessary SUID bits, restricts `/etc/shadow` to root and shadow group, and enforces SSH configuration best practices. Disabling password-based SSH authentication and restricting root login reduces the attack surface for brute-force and credential stuffing attacks (NIST, 2020).

**Key concepts:** Principle of least privilege, SSH hardening (`sshd_config`), umask defaults, automated remediation scripts.

## Session 3: Stream Editing & Log Parsing

`sed`, `awk`, `grep`, and `cut` were combined to parse authentication logs and extract actionable intelligence. One-liner pipelines identified top attacker IPs from failed SSH attempts without requiring dedicated SIEM tooling. Log parsing is a foundational SOC skill; the ability to extract signal from noise using command-line tools underpins efficient triage workflows (SANS Institute, 2019).

**Key concepts:** `sed` substitution, `awk` field extraction, `grep` pattern matching, pipeline chaining, log triage.

## References

Kerrisk, M. (2010). *The Linux programming interface*. No Starch Press.

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST SP 800-53 Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

SANS Institute. (2019). *Linux command line forensics and incident response*. SANS Reading Room. https://www.sans.org/reading-room/
