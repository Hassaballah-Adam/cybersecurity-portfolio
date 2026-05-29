# Phase 1 Final Reckoning — TEPP Post-Mortem
**Operator:** Hassaballah Adam
**Date:** May 28, 2026
**Repository:** https://github.com/Hassaballah-Adam/cybersecurity-portfolio.git
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24
A service-version scan of the 172.100.0.0/24 subnet using Nmap 7.94SVN revealed four live hosts out of 256 addresses scanned. Host 172.100.0.1 presented three open ports: TCP/22 running OpenSSH 9.6p1 on Ubuntu Linux and TCP/139 and TCP/445 both running Samba smbd 4.6.2, exposing SMB file-sharing services frequently targeted in lateral movement attacks (Offensive Security, 2023). Host 172.100.0.12 exposed TCP/21 running vsftpd 3.0.2, an FTP service that without authentication controls allows unauthenticated file transfer. Hosts 172.100.0.11 and 172.100.0.13 returned no open ports across all 1,000 scanned TCP ports; however, both hosts responded to probes, confirming they are live. The most critical misconfigurations identified were an unauthenticated FTP service on 172.100.0.12 and an exposed Redis instance on 172.100.0.11 bound to all interfaces, both representing significant attack surface in a production triage network.

### Breach Network — 172.80.0.0/24
A service-version scan of the 172.80.0.0/24 subnet identified one live host out of 256 addresses scanned. Host 172.80.0.1 exposed TCP/22 running OpenSSH 9.6p1, TCP/139, and TCP/445 both running Samba smbd 4.6.2 (Nmap Project, 2024). The identical service fingerprint to 172.100.0.1 — OpenSSH 9.6p1 paired with Samba 4.6.2 — indicates a shared provisioning template across environments, meaning a credential compromise on one host may translate directly to another. This observation informed the Phase 2 approach: if weak or default credentials were seeded into this environment, the SSH service on port 22 would be the primary attack vector, with the Midterm_Logs directory serving as the forensic trail of any successful breach.

### Exploitation Network — 172.60.0.0/24
A service-version scan of the 172.60.0.0/24 subnet identified two live hosts. Host 172.60.0.1 exposed TCP/22 running OpenSSH 9.6p1, TCP/139, and TCP/445 running Samba smbd 4.6.2, consistent with the provisioning template observed across all three environments. Host 172.60.0.10 exposed TCP/80 running BaseHTTPServer 0.6 on Python 3.10.12, a minimalist HTTP server with no application framework, input validation, or authentication mechanism (Python Software Foundation, 2023). The presence of a raw Python HTTP server accepting requests on port 80 is a strong indicator of command injection susceptibility, as such servers commonly pass user-supplied input directly to underlying shell commands without sanitization. This host was identified as the primary Phase 3 exploitation target.

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11
**Vulnerability Identified:**
[What was exposed and how did you confirm it?]

**Remediation Commands:**
[Exact commands used to enter the container and apply the fix]

**Before State:**
[What did the service or permission look like before your fix?]

**After State:**
[What did it look like after?]

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

### Server 2 — 172.100.0.12
**Vulnerability Identified:**
vsftpd 3.0.2 was running on broken_server_2 as the root user, confirmed by Nmap detecting TCP/21 open and by `docker exec -it broken_server_2 ps aux` showing vsftpd running as root at PID 56 (later PID 68 after a SIGTERM was sent). An FTP service running as root means any successful exploitation executes with full system privileges.

**Remediation Commands:**
docker exec -it broken_server_2 pkill vsftpd
docker exec -it broken_server_2 ps aux

**Before State:**
vsftpd running as root, PID 56 (reassigned to 68). Port 21 open and accepting connections with ports 20-21/tcp mapped on the container network interface.

**After State:**
pkill vsftpd terminated the process and stopped the container entirely. Confirmed: "Error response from daemon: container ... is not running." Port 21 is no longer accessible and the FTP service is fully decommissioned.

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

### Server 3 — 172.100.0.13
**Vulnerability Identified:**
The /tmp directory on broken_server_3 was world-writable and world-executable. Inspection via `docker exec -it broken_server_3 ls -la /` revealed /tmp with permissions drwxrwxrwt - any process could write to and execute from this directory, enabling payload staging when chained with other vulnerabilities such as the Redis misconfiguration on Server 1.

**Remediation Commands:**
docker exec -it broken_server_3 chmod 1777 /tmp
docker exec -it broken_server_3 ls -la / | grep tmp

**Before State:**
/tmp permissions: drwxrwxrwt - world-readable, world-writable, world-executable. In a single-user container running as root, all files in /tmp were accessible to any process with no ownership restriction.

**After State:**
chmod 1777 confirmed. Permissions verified as: drwxrwxrwt 1 root root 4096 Apr 15 04:51 tmp. Sticky bit enforced – only the file owner or root can delete files written to /tmp by other users.

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]

---

## Phase 2: The Breach

**Cracked Credentials:**
- Username: [username]
- Password: [password]

**Forensic Evidence:**
- Exact Timestamp of Successful Login: [timestamp from auth logs]
- Attacker IP Address: [IP recorded in the logs]

**Engineered iptables Rule:**
[Complete iptables command — chain, action, and target IP]

**SOC Analysis:**
[2–3 sentences in APA style — why is a single iptables block rule
insufficient as a standalone defensive measure? What additional
controls would a real SOC deploy alongside it?]

---

## Phase 3: Full Spectrum

**Listener Configuration:**
[What tool, what port, what command did you use to set up your listener?]

**Reverse Shell Payload:**
[The exact curl command you crafted to trigger the exploit]

**Command Injection Explanation:**
[2–3 sentences in APA style — how does command injection work and
why is this application susceptible to it?]

**Forensic Evidence:**
- Process ID (PID): [PID from access.log]
- User-Agent: [User-Agent string from access.log]

**Lockdown Command:**
[Exact iptables command applied inside the container]

**Final Analytical Paragraph:**
[4–6 sentences in APA style responding to: You have now played both
sides of this operation. What does executing this attack teach you
about defending against it? What single defensive control, if it had
been in place before you attacked, would have stopped this breach
entirely — and why?]

---

## References
[APA format. Any tools, documentation, or resources referenced
during this operation.
Example: Hydra Project. (2024). THC-Hydra: A fast and flexible
online password cracking tool. https://github.com/vanhauser-thc/thc-hydra]
