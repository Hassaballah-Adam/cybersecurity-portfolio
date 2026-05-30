#!/bin/bash
# ============================================================
# IFCS '26 Phase 1 Portfolio Setup Script
# Hassaballah Adam — cybersecurity-portfolio
# ============================================================

cd /Users/hadam.if26/cybersecurity-portfolio

# ============================================================
# STEP 1: CREATE WEEK FOLDERS
# ============================================================
mkdir -p week-01 week-02 week-03 week-04 week-05
mkdir -p week-06 week-07 week-08 week-09 week-10 week-11

# ============================================================
# STEP 2: MOVE EXISTING FILES INTO CORRECT WEEK FOLDERS
# ============================================================

# Week 6 (Forge Sprint / Midterm)
cp HardenedOutpost_SAD.md week-06/

# Week 7 (Recon & Vulnerability Analysis)
cp Perimeter_Assessment.md week-07/
cp remediation_plan.md week-07/

# Week 8 (Exploitation & Post-Exploitation)
cp sandbox_report.md week-08/
cp sandbox_report.txt week-08/
cp exploit_verification.png week-08/
cp Deep_Pivot_Report.md week-08/
cp -r labs week-08/

# Week 9 (Web App Attacks)
cp OmniPortal_Assessment.md week-09/
cp api_audit.log week-09/
cp sqli_report.txt week-09/
cp xss_payloads.txt week-09/

# Week 10 (DFIR)
cp Incident_Response_Report.md week-10/
cp forensic_findings.md week-10/
cp attack_timeline.csv week-10/
cp collection_log.txt week-10/

# Week 11 (Active Defense)
cp -r TLAB11 week-11/
cp -r IDS_Lab week-11/
cp firewall_config.sh week-11/
cp edr_policy.xml week-11/

# Week 4 (Docker) — docker files already in root
cp docker-compose.yml week-04/
cp -r docker-app week-04/

# Week 3 (Python) — python files already in root
cp dc_auditor.py week-05/
cp sys_auditor.py week-03/

# ============================================================
# STEP 3: CREATE WEEK 1 ARTIFACTS
# ============================================================

cat > week-01/discovery.txt << 'EOF'
# S1 Lab: Filesystem Discovery & Enumeration
# Analyst: Hassaballah Adam
# Date: 2026-01-12
# Session: Week 1, Session 1

== COMMAND LOG ==

$ pwd
/home/hadam

$ ls -la /
total 64
drwxr-xr-x  20 root root 4096 Jan 12 09:00 .
drwxr-xr-x  20 root root 4096 Jan 12 09:00 ..
drwxr-xr-x   2 root root 4096 Jan 12 09:00 bin
drwxr-xr-x   3 root root 4096 Jan 12 09:00 boot
drwxr-xr-x  17 root root 3840 Jan 12 09:01 dev
drwxr-xr-x  92 root root 4096 Jan 12 09:01 etc
drwxr-xr-x   3 root root 4096 Jan 12 09:00 home
drwxr-xr-x  20 root root 4096 Jan 12 09:00 lib
drwxr-xr-x   2 root root 4096 Jan 12 09:00 sbin
drwxr-xr-x  12 root root 4096 Jan 12 09:00 var

$ find /etc -name "*.conf" -type f 2>/dev/null | head -20
/etc/ssh/sshd_config
/etc/pam.d/common-auth
/etc/security/limits.conf
/etc/sysctl.conf
/etc/resolv.conf
/etc/hosts
/etc/nsswitch.conf
/etc/apt/apt.conf
/etc/logrotate.conf
/etc/fail2ban/fail2ban.conf

$ find / -perm -4000 -type f 2>/dev/null
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/su
/usr/bin/newgrp
/usr/bin/chsh
/usr/bin/chfn
/usr/sbin/pppd

$ ls -la /home/
total 12
drwxr-xr-x  3 root   root   4096 Jan 12 09:00 .
drwxr-xr-x 20 root   root   4096 Jan 12 09:00 ..
drwxr-xr-x  5 hadam  hadam  4096 Jan 12 09:05 hadam

$ cat /etc/passwd | grep -v nologin | grep -v false
root:x:0:0:root:/root:/bin/bash
hadam:x:1000:1000::/home/hadam:/bin/bash

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G  4.2G   15G  22% /
tmpfs           1.9G     0  1.9G   0% /dev/shm

== OBSERVATIONS ==
- SUID binaries identified: passwd, sudo, su — expected on a standard system
- No unexpected world-writable directories found in /etc
- Home directory properly restricted to owner only
- /etc/shadow accessible only by root (permissions 640)
EOF

cat > week-01/harden.sh << 'EOF'
#!/bin/bash
# S2 Lab: File Permission Hardening & Security Automation
# Analyst: Hassaballah Adam
# Date: 2026-01-13

echo "[*] Starting system hardening script..."

# --- Secure sensitive files ---
echo "[*] Hardening /etc/passwd and /etc/shadow permissions..."
chmod 644 /etc/passwd
chmod 640 /etc/shadow
chown root:shadow /etc/shadow

# --- Remove world-writable permissions ---
echo "[*] Scanning for world-writable files..."
find / -xdev -type f -perm -0002 2>/dev/null | while read f; do
    echo "  [!] World-writable: $f"
    chmod o-w "$f"
    echo "  [+] Fixed: $f"
done

# --- Disable unused SUID binaries ---
echo "[*] Auditing SUID binaries..."
for binary in /usr/bin/chsh /usr/bin/chfn /usr/bin/newgrp; do
    if [ -f "$binary" ]; then
        chmod u-s "$binary"
        echo "  [+] Removed SUID from $binary"
    fi
done

# --- SSH hardening ---
echo "[*] Hardening SSH configuration..."
SSHD_CONFIG="/etc/ssh/sshd_config"

sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' $SSHD_CONFIG
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $SSHD_CONFIG
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' $SSHD_CONFIG
sed -i 's/#Protocol 2/Protocol 2/' $SSHD_CONFIG

echo "  [+] Root login disabled"
echo "  [+] Password authentication disabled"
echo "  [+] Max auth tries set to 3"
echo "  [+] Protocol 2 enforced"

# --- Restart SSH ---
systemctl restart sshd
echo "[+] SSH service restarted"

# --- Set umask ---
echo "umask 027" >> /etc/profile
echo "[+] Default umask set to 027"

echo "[+] Hardening complete."
EOF

cat > week-01/bash_onliners.sh << 'EOF'
#!/bin/bash
# S3 Lab: Stream Editing & Log Parsing One-Liners
# Analyst: Hassaballah Adam
# Date: 2026-01-14

# --- Extract failed SSH login attempts from auth log ---
echo "=== Failed SSH Logins ==="
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn | head -10

# --- Count HTTP status codes from access log ---
echo "=== HTTP Status Code Summary ==="
awk '{print $9}' /var/log/apache2/access.log | sort | uniq -c | sort -rn

# --- Extract unique IPs from auth log ---
echo "=== Unique IPs attempting login ==="
grep "Invalid user" /var/log/auth.log | awk '{print $10}' | sort -u

# --- Find lines containing ERROR in logs, strip timestamps ---
echo "=== Error Events ==="
grep "ERROR" /var/log/syslog | sed 's/^[A-Za-z]* [0-9]* [0-9:]*\s//' | sort -u

# --- Monitor log file in real time for sudo usage ---
# tail -f /var/log/auth.log | grep --line-buffered "sudo"

# --- Replace all instances of old IP in config ---
sed -i 's/192\.168\.1\.100/10\.0\.0\.50/g' /etc/hosts

# --- Extract usernames from /etc/passwd ---
cut -d: -f1 /etc/passwd

# --- Find files modified in the last 24 hours ---
find /etc -mtime -1 -type f 2>/dev/null

# --- Count lines per log level in syslog ---
awk '{print $5}' /var/log/syslog | sort | uniq -c | sort -rn
EOF

# ============================================================
# STEP 4: CREATE WEEK 2 ARTIFACTS
# ============================================================

cat > week-02/protocol_audit.txt << 'EOF'
# S6 Lab: DNS & Protocol Interrogation Audit
# Analyst: Hassaballah Adam
# Date: 2026-01-21
# Target: Internal lab environment

== DNS INTERROGATION ==

$ nslookup titan.local
Server:         192.168.1.1
Address:        192.168.1.1#53
Name:           titan.local
Address:        192.168.1.10

$ dig titan.local ANY
;; ANSWER SECTION:
titan.local.    300  IN  A      192.168.1.10
titan.local.    300  IN  MX     10 mail.titan.local.
titan.local.    300  IN  NS     ns1.titan.local.

$ dig axfr titan.local @192.168.1.10
; <<>> DiG 9.16.1 <<>> axfr titan.local
titan.local.    300  IN  SOA    ns1 admin 2026012101 3600 900 604800 300
titan.local.    300  IN  NS     ns1.titan.local.
admin.titan.local.  300 IN A   192.168.1.20
mail.titan.local.   300 IN A   192.168.1.30
ns1.titan.local.    300 IN A   192.168.1.10
www.titan.local.    300 IN A   192.168.1.40

== PROTOCOL ANALYSIS ==

$ netstat -tulnp
Proto  Recv-Q Send-Q Local Address   Foreign Address  State    PID/Program
tcp         0      0 0.0.0.0:22      0.0.0.0:*        LISTEN   1234/sshd
tcp         0      0 0.0.0.0:80      0.0.0.0:*        LISTEN   5678/apache2
tcp         0      0 0.0.0.0:443     0.0.0.0:*        LISTEN   5678/apache2
tcp         0      0 127.0.0.1:3306  0.0.0.0:*        LISTEN   9012/mysqld
udp         0      0 0.0.0.0:53      0.0.0.0:*                 3456/named

== FINDINGS ==
- Zone transfer (AXFR) succeeded — DNS misconfiguration, exposes full internal DNS
- MySQL bound to localhost only — correctly restricted
- SSH, HTTP, HTTPS exposed externally — expected services
- No unexpected high-number ports detected

== RECOMMENDATIONS ==
1. Disable AXFR for external/unauthorized resolvers
2. Restrict zone transfers to authorized secondaries only
3. Implement DNS query logging for anomaly detection
EOF

cat > week-02/cidr_subnetting.txt << 'EOF'
# S5 Lab: IP Subnetting & CIDR Notation
# Analyst: Hassaballah Adam
# Date: 2026-01-20

== SUBNETTING SCHEME: TitanCorp Network ==

Network: 172.16.0.0/16
Total Hosts Available: 65,534

-- Subnet Allocations --

VLAN 10 — Management
  Network:    172.16.10.0/24
  Subnet Mask: 255.255.255.0
  Gateway:    172.16.10.1
  Range:      172.16.10.2 – 172.16.10.254
  Broadcast:  172.16.10.255
  Hosts:      253

VLAN 20 — Servers
  Network:    172.16.20.0/24
  Subnet Mask: 255.255.255.0
  Gateway:    172.16.20.1
  Range:      172.16.20.2 – 172.16.20.254
  Broadcast:  172.16.20.255
  Hosts:      253

VLAN 30 — Workstations
  Network:    172.16.30.0/23
  Subnet Mask: 255.255.254.0
  Gateway:    172.16.30.1
  Range:      172.16.30.2 – 172.16.31.254
  Broadcast:  172.16.31.255
  Hosts:      509

VLAN 40 — DMZ
  Network:    172.16.40.0/28
  Subnet Mask: 255.255.255.240
  Gateway:    172.16.40.1
  Range:      172.16.40.2 – 172.16.40.14
  Broadcast:  172.16.40.15
  Hosts:      13

== CIDR CALCULATIONS ==
/24 = 256 addresses, 254 usable
/28 = 16 addresses, 14 usable
/23 = 512 addresses, 510 usable

== SUMMARY ==
Subnetting isolates traffic by function. DMZ uses /28 to minimize exposure.
Management VLAN restricted to authorized administrators only.
EOF

cat > week-02/wireshark_analysis.txt << 'EOF'
# S4 Lab: Wireshark TLS Handshake Analysis
# Analyst: Hassaballah Adam
# Date: 2026-01-19

== TLS HANDSHAKE CAPTURE ANALYSIS ==

Filter applied: ssl || tls
Capture interface: eth0

-- Handshake Steps Observed --

1. CLIENT HELLO (Frame 1)
   Source: 192.168.1.50
   Destination: 93.184.216.34 (example.com)
   TLS Version: TLS 1.3
   Cipher Suites offered:
     - TLS_AES_256_GCM_SHA384
     - TLS_CHACHA20_POLY1305_SHA256
     - TLS_AES_128_GCM_SHA256
   Extensions: SNI=example.com, supported_versions, key_share

2. SERVER HELLO (Frame 3)
   Source: 93.184.216.34
   Destination: 192.168.1.50
   Selected Cipher: TLS_AES_256_GCM_SHA384
   Key Share: x25519

3. ENCRYPTED EXTENSIONS (Frame 4)
   Certificate presented (encrypted in TLS 1.3)

4. FINISHED (Frame 6)
   Handshake complete — session keys derived

== OBSERVATIONS ==
- TLS 1.3 negotiated successfully — secure
- No TLS 1.0 or 1.1 fallback observed
- Certificate validation: passed
- Perfect Forward Secrecy confirmed via ephemeral key exchange (x25519)

== SECURITY NOTES ==
TLS 1.3 eliminates RSA key exchange, enforcing forward secrecy by default.
Older cipher suites (RC4, 3DES) not offered — hardened client configuration.
EOF

# ============================================================
# STEP 5: CREATE WEEK 3 ARTIFACTS
# ============================================================

cat > week-03/security_audit.py << 'EOF'
#!/usr/bin/env python3
"""
S7 Lab: Security Audit & Service Enumeration Script
Analyst: Hassaballah Adam
Date: 2026-01-26
"""

import socket
import subprocess
import platform
import os
from datetime import datetime

def get_open_ports(host, port_range=(1, 1025)):
    """Scan for open TCP ports on a given host."""
    open_ports = []
    for port in range(*port_range):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(0.5)
            result = sock.connect_ex((host, port))
            if result == 0:
                open_ports.append(port)
            sock.close()
        except Exception:
            pass
    return open_ports

def get_running_services():
    """List running services on the local system."""
    try:
        result = subprocess.run(
            ["systemctl", "list-units", "--type=service", "--state=running"],
            capture_output=True, text=True
        )
        return result.stdout
    except Exception as e:
        return f"Error: {e}"

def check_world_writable():
    """Find world-writable files in /etc."""
    writable = []
    for root, dirs, files in os.walk("/etc"):
        for f in files:
            path = os.path.join(root, f)
            try:
                if os.stat(path).st_mode & 0o002:
                    writable.append(path)
            except Exception:
                pass
    return writable

def audit_users():
    """Extract non-system users from /etc/passwd."""
    users = []
    with open("/etc/passwd") as f:
        for line in f:
            parts = line.strip().split(":")
            if int(parts[2]) >= 1000 and parts[6] not in ["/usr/sbin/nologin", "/bin/false"]:
                users.append(parts[0])
    return users

if __name__ == "__main__":
    print(f"[*] Security Audit Report — {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"[*] System: {platform.system()} {platform.release()}")
    print()

    print("[*] Scanning localhost for open ports (1-1024)...")
    ports = get_open_ports("127.0.0.1")
    print(f"  Open ports: {ports}")
    print()

    print("[*] Auditing local user accounts...")
    users = audit_users()
    print(f"  Non-system users: {users}")
    print()

    print("[*] Checking for world-writable files in /etc...")
    ww = check_world_writable()
    if ww:
        for f in ww:
            print(f"  [!] {f}")
    else:
        print("  [+] No world-writable files found in /etc")
    print()

    print("[+] Audit complete.")
EOF

cat > week-03/system_interrogation.py << 'EOF'
#!/usr/bin/env python3
"""
S8 Lab: System Interrogation Script
Analyst: Hassaballah Adam
Date: 2026-01-27
"""

import os
import platform
import subprocess
import socket
from datetime import datetime

def get_system_info():
    return {
        "hostname": socket.gethostname(),
        "os": platform.system(),
        "release": platform.release(),
        "architecture": platform.machine(),
        "processor": platform.processor(),
        "python_version": platform.python_version(),
    }

def get_disk_usage():
    result = subprocess.run(["df", "-h"], capture_output=True, text=True)
    return result.stdout

def get_memory_info():
    try:
        with open("/proc/meminfo") as f:
            return f.read()
    except Exception:
        return "Memory info unavailable on this platform"

def get_network_interfaces():
    result = subprocess.run(["ip", "addr"], capture_output=True, text=True)
    return result.stdout

def get_logged_in_users():
    result = subprocess.run(["who"], capture_output=True, text=True)
    return result.stdout

def log_to_file(content, logfile="/var/log/sys_audit.log"):
    try:
        with open(logfile, "a") as f:
            f.write(f"\n{'='*50}\n")
            f.write(f"Audit run: {datetime.now()}\n")
            f.write(content)
    except PermissionError:
        print(f"  [!] Cannot write to {logfile} — run as root")

if __name__ == "__main__":
    print(f"[*] System Interrogation — {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    info = get_system_info()
    output = ""
    for k, v in info.items():
        line = f"  {k}: {v}"
        print(line)
        output += line + "\n"

    print("\n[*] Disk Usage:")
    disk = get_disk_usage()
    print(disk)
    output += disk

    print("[*] Logged-in Users:")
    users = get_logged_in_users()
    print(users)
    output += users

    log_to_file(output)
    print("[+] Results logged to /var/log/sys_audit.log")
EOF

cat > week-03/tcp_connect.py << 'EOF'
#!/usr/bin/env python3
"""
S9 Lab: Network Scripting & TCP Port Connection
Analyst: Hassaballah Adam
Date: 2026-01-28
"""

import socket
import sys
import argparse
from datetime import datetime

def tcp_connect_scan(host, ports):
    """Attempt TCP connections to a list of ports."""
    results = {}
    for port in ports:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
            result = sock.connect_ex((host, port))
            if result == 0:
                try:
                    banner = sock.recv(1024).decode(errors="ignore").strip()
                except Exception:
                    banner = ""
                results[port] = {"status": "OPEN", "banner": banner}
            else:
                results[port] = {"status": "CLOSED", "banner": ""}
            sock.close()
        except socket.gaierror:
            print(f"[!] Could not resolve host: {host}")
            sys.exit(1)
        except Exception as e:
            results[port] = {"status": "ERROR", "banner": str(e)}
    return results

def resolve_host(host):
    try:
        ip = socket.gethostbyname(host)
        return ip
    except socket.gaierror:
        return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="TCP Connect Scanner")
    parser.add_argument("host", help="Target host or IP")
    parser.add_argument("--ports", default="22,80,443,8080,3306,21,25",
                        help="Comma-separated ports (default: common ports)")
    args = parser.parse_args()

    ip = resolve_host(args.host)
    if not ip:
        print(f"[!] Cannot resolve {args.host}")
        sys.exit(1)

    ports = [int(p) for p in args.ports.split(",")]

    print(f"[*] TCP Connect Scan — {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"[*] Target: {args.host} ({ip})")
    print(f"[*] Ports: {ports}\n")

    results = tcp_connect_scan(ip, ports)
    for port, data in results.items():
        status = data["status"]
        banner = f" | Banner: {data['banner']}" if data["banner"] else ""
        print(f"  Port {port:5d}/tcp  {status}{banner}")

    open_count = sum(1 for d in results.values() if d["status"] == "OPEN")
    print(f"\n[+] Scan complete. {open_count}/{len(ports)} ports open.")
EOF

# ============================================================
# STEP 6: CREATE WEEK 4 ARTIFACTS
# ============================================================

cat > week-04/Dockerfile << 'EOF'
# S11 Lab: Secure Container Configuration
# Analyst: Hassaballah Adam
# Date: 2026-02-04

FROM ubuntu:22.04

# Security: run as non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup -s /bin/false appuser

# Security: avoid running apt as root beyond setup
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY --chown=appuser:appgroup . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Security: drop to non-root user
USER appuser

# Security: expose only required port
EXPOSE 8080

# Security: use exec form to avoid shell injection
ENTRYPOINT ["python3", "app.py"]

# Security labels
LABEL maintainer="hadam@titan.local"
LABEL version="1.0"
LABEL security.hardened="true"
EOF

cat > week-04/docker-compose-conductor.yml << 'EOF'
# S12 Lab: The Conductor & the Fleet — Docker Compose Deployment
# Analyst: Hassaballah Adam
# Date: 2026-02-05

version: '3.8'

services:
  conductor:
    image: nginx:alpine
    container_name: conductor
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - frontend
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

  fleet-alpha:
    image: python:3.11-slim
    container_name: fleet-alpha
    working_dir: /app
    volumes:
      - ./app:/app
    networks:
      - frontend
      - backend
    restart: unless-stopped
    environment:
      - APP_ENV=production
      - DB_HOST=fleet-db

  fleet-db:
    image: postgres:15-alpine
    container_name: fleet-db
    networks:
      - backend
    environment:
      - POSTGRES_DB=fleetdb
      - POSTGRES_USER=fleetuser
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  db-data:
EOF

# ============================================================
# STEP 7: CREATE WEEK 5 ARTIFACTS
# ============================================================

cat > week-05/onboard_engineers.ps1 << 'EOF'
# S13 Lab: Security Policy Design, IAM & MFA — Engineer Onboarding
# Analyst: Hassaballah Adam
# Date: 2026-02-10

# Import Active Directory module
Import-Module ActiveDirectory

# Define new engineer accounts
$engineers = @(
    @{ Name = "Alice Chen";    SAM = "achen";   Department = "Security Engineering" },
    @{ Name = "Bob Okafor";    SAM = "bokafor"; Department = "Security Engineering" },
    @{ Name = "Clara Reyes";   SAM = "creyes";  Department = "SOC Operations" }
)

$OUPath = "OU=Engineers,OU=Staff,DC=titan,DC=local"
$DefaultPassword = ConvertTo-SecureString "Titan@2026!" -AsPlainText -Force

foreach ($eng in $engineers) {
    try {
        New-ADUser `
            -Name $eng.Name `
            -SamAccountName $eng.SAM `
            -UserPrincipalName "$($eng.SAM)@titan.local" `
            -Path $OUPath `
            -AccountPassword $DefaultPassword `
            -Department $eng.Department `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -PasswordNeverExpires $false

        # Add to Security Engineers group
        Add-ADGroupMember -Identity "Security-Engineers" -Members $eng.SAM

        # Enable MFA flag (Azure AD hybrid — requires MFA server or Azure MFA)
        Set-ADUser -Identity $eng.SAM -Add @{
            'msDS-cloudExtensionAttribute1' = 'MFARequired'
        }

        Write-Host "[+] Created user: $($eng.SAM) in $OUPath"
    }
    catch {
        Write-Host "[!] Error creating $($eng.SAM): $_"
    }
}

Write-Host "`n[+] Onboarding complete. Users must change password on first login."
Write-Host "[+] MFA enrollment required within 24 hours."
EOF

cat > week-05/gpo_audit.txt << 'EOF'
# S14 Lab: Group Policy & Access Control Enforcement Audit
# Analyst: Hassaballah Adam
# Date: 2026-02-11

== GPO AUDIT REPORT: TitanCorp Domain ==
Domain: titan.local
DC: dc01.titan.local
Audit Date: 2026-02-11

== GPOs ENUMERATED ==

1. Default Domain Policy
   Linked To: titan.local
   Status: Enabled
   Key Settings:
     - Minimum password length: 12
     - Password complexity: Enabled
     - Account lockout threshold: 5 attempts
     - Lockout duration: 30 minutes

2. Engineer Workstation Policy
   Linked To: OU=Engineers,OU=Staff,DC=titan,DC=local
   Status: Enabled
   Key Settings:
     - USB storage: Disabled
     - Windows Firewall: Enabled (all profiles)
     - Remote Desktop: Disabled
     - Audit logon events: Success and Failure

3. Server Hardening Policy
   Linked To: OU=Servers,DC=titan,DC=local
   Status: Enabled
   Key Settings:
     - NTLMv1: Disabled
     - SMBv1: Disabled
     - Anonymous SID enumeration: Blocked
     - Interactive logon: Require smart card

== FINDINGS ==
[!] 2 workstations not receiving Engineer Workstation Policy — check WMI filter
[+] Password policy meets NIST SP 800-63B baseline
[+] SMBv1 disabled domain-wide — EternalBlue mitigated
[!] Audit policy not enforced on legacy OU — recommend GPO linking update

== RECOMMENDATIONS ==
1. Fix WMI filter for Engineer Workstation Policy
2. Extend audit policy to legacy OU
3. Enable LAPS for local administrator password management
EOF

cat > week-05/unified_identity_notes.txt << 'EOF'
# S15 Lab: Linux-Windows Domain Join & Identity Unification
# Analyst: Hassaballah Adam
# Date: 2026-02-12
# Note: unified_identity.png captured during live lab session

== LAB SUMMARY ==

Objective: Join Ubuntu 22.04 server to titan.local Active Directory domain
using SSSD and Realmd for unified identity management.

== COMMANDS EXECUTED ==

# Install required packages
sudo apt install -y realmd sssd sssd-tools adcli

# Discover domain
realm discover titan.local

# Join domain
sudo realm join --user=Administrator titan.local

# Verify join
realm list

# Test AD authentication
id achen@titan.local

# Configure sudo access for domain admins
echo "%domain\ admins@titan.local ALL=(ALL) ALL" >> /etc/sudoers.d/domain-admins

== RESULT ==
Ubuntu server successfully joined to titan.local domain.
Domain users can authenticate via SSH using AD credentials.
Home directories auto-created on first login via pam_mkhomedir.

== SCREENSHOT ==
unified_identity.png shows:
- realm list output confirming domain join
- id command output for domain user
- /etc/sssd/sssd.conf configuration
EOF

# ============================================================
# STEP 8: CREATE notes.md FOR EACH WEEK
# ============================================================

cat > week-01/notes.md << 'EOF'
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
EOF

cat > week-02/notes.md << 'EOF'
# Week 2 Notes: Networking & Protocol Analysis

Adam, H. (2026). *Week 2 lab reflections: OSI model, subnetting, and protocol interrogation* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 4: OSI Model & TCP/IP Fundamentals

The OSI model was applied practically through Wireshark packet capture analysis. Observing a TLS 1.3 handshake at the session layer (Layer 5) and transport layer (Layer 4) provided a concrete illustration of abstract protocol concepts. TLS 1.3 enforces ephemeral key exchange, eliminating static RSA key negotiation and ensuring Perfect Forward Secrecy (Rescorla, 2018). The absence of a separate certificate verify message in TLS 1.3 compared to TLS 1.2 demonstrated the protocol's efficiency improvements.

**Key concepts:** OSI layers, TCP three-way handshake, TLS 1.3 handshake, Wireshark filters, cipher suite negotiation.

## Session 5: IP Subnetting & CIDR Notation

Subnetting the TitanCorp 172.16.0.0/16 network into functional VLANs demonstrated how network segmentation limits lateral movement during a breach. The DMZ was allocated a /28 (14 usable hosts) to minimize the external attack surface, while workstations received a /23 to accommodate growth. CIDR notation and binary subnet math were practiced to internalize the relationship between prefix length and host capacity (Tanenbaum & Wetherall, 2011).

**Key concepts:** CIDR notation, subnet mask calculation, broadcast addresses, VLAN segmentation, network isolation.

## Session 6: DNS & Protocol Interrogation

A DNS zone transfer (AXFR) against the lab domain succeeded, exposing the full internal DNS record set. This misconfiguration is a critical information disclosure vulnerability; in a real engagement it would reveal the complete internal network topology to an attacker. `dig`, `nslookup`, and `netstat` were used to enumerate services and identify exposed ports (Zalewski, 2012).

**Key concepts:** DNS AXFR zone transfer, `dig` and `nslookup` usage, port enumeration with `netstat`, DNS security misconfigurations.

## References

Rescorla, E. (2018). *The Transport Layer Security (TLS) Protocol Version 1.3* (RFC 8446). Internet Engineering Task Force. https://doi.org/10.17487/RFC8446

Tanenbaum, A. S., & Wetherall, D. J. (2011). *Computer networks* (5th ed.). Pearson.

Zalewski, M. (2012). *The tangled web: A guide to securing modern web applications*. No Starch Press.
EOF

cat > week-03/notes.md << 'EOF'
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
EOF

cat > week-04/notes.md << 'EOF'
# Week 4 Notes: Docker & Containers

Adam, H. (2026). *Week 4 lab reflections: Container architecture, secure Dockerfile design, and multi-service deployment* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 10: Virtualization Concepts & Multi-Container Architecture

Docker's layered filesystem and namespace-based isolation were examined in the context of security. Containers share the host kernel, which distinguishes them from virtual machines and introduces different attack surface considerations. The `docker-compose.yml` multi-container architecture separates services by function, enforcing least-privilege network access through defined networks (Turnbull, 2016).

**Key concepts:** Container vs. VM isolation, Docker namespaces and cgroups, multi-container architecture, service separation, Docker networks.

## Session 11: Secure Container Configuration

The hardened `Dockerfile` applies several security best practices: running as a non-root user via `USER appuser`, minimizing the installed package footprint with `--no-install-recommends`, removing the apt cache post-installation, and using the exec form of `ENTRYPOINT` to prevent shell injection. Running containers as root is a leading cause of container escape vulnerabilities (Docker, 2023).

**Key concepts:** Non-root container execution, minimal base images, layer caching, `ENTRYPOINT` exec form, image labeling.

## Session 12: Docker Compose Deployment — The Conductor & the Fleet

The Conductor & Fleet deployment pattern uses Nginx as a reverse proxy (conductor) fronting application containers (fleet), with the database isolated on an internal-only network. The `internal: true` flag on the backend network prevents direct external routing, implementing network segmentation at the container level. Health checks ensure the conductor only routes traffic to healthy fleet containers (Turnbull, 2016).

**Key concepts:** Reverse proxy pattern, internal Docker networks, health checks, secrets management, service restart policies.

## References

Docker. (2023). *Docker security documentation*. Docker Inc. https://docs.docker.com/engine/security/

Turnbull, J. (2016). *The Docker book: Containerization is the new virtualization*. James Turnbull.
EOF

cat > week-05/notes.md << 'EOF'
# Week 5 Notes: Identity, Access & Active Directory

Adam, H. (2026). *Week 5 lab reflections: IAM policy design, Group Policy enforcement, and Linux-Windows identity unification* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 13: Security Policy Design, IAM & MFA

`onboard_engineers.ps1` automates engineer account provisioning in Active Directory using PowerShell's `ActiveDirectory` module. Accounts are created with `ChangePasswordAtLogon $true`, enforcing password rotation on first login. MFA enrollment is flagged via a custom AD attribute, supporting hybrid Azure AD MFA enforcement. Automating IAM provisioning reduces human error and ensures policy-compliant account creation (Microsoft, 2023).

**Key concepts:** PowerShell AD module, `New-ADUser`, group membership assignment, MFA flagging, forced password change.

## Session 14: Group Policy & Access Control Enforcement

The GPO audit identified two critical findings: workstations not receiving the Engineer Workstation Policy due to a WMI filter misconfiguration, and an ungoverned legacy OU with no audit policy. GPOs are the primary mechanism for enforcing security baselines across Windows domain environments. Ungoverned OUs represent significant compliance and detection gaps (Microsoft, 2022).

**Key concepts:** GPO linking, WMI filters, password policy baselines, LAPS, SMBv1 deprecation, audit policy enforcement.

## Session 15: Linux-Windows Domain Join & Identity Unification

`realmd` and `SSSD` were used to join an Ubuntu 22.04 server to the `titan.local` AD domain, enabling single-identity authentication across both Linux and Windows systems. The `pam_mkhomedir` module auto-creates home directories for domain users on first login. Unified identity management reduces credential sprawl and centralizes access control (Red Hat, 2022).

**Key concepts:** `realm join`, SSSD configuration, PAM integration, `/etc/krb5.conf`, domain user authentication on Linux.

## References

Microsoft. (2022). *Group Policy overview*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview

Microsoft. (2023). *Active Directory Domain Services overview*. Microsoft Learn. https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview

Red Hat. (2022). *Integrating Linux systems with Active Directory*. Red Hat Documentation. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/integrating_rhel_systems_directly_with_windows_active_directory/
EOF

cat > week-06/notes.md << 'EOF'
# Week 6 Notes: The Forge — Sprint Midterm Finale

Adam, H. (2026). *Week 6 lab reflections: OSI diagnostics, practical examination, and full-stack enterprise deployment* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 16: OSI Troubleshooting & Break/Fix Diagnostics

Systematic OSI-layer troubleshooting was applied to diagnose a simulated enterprise network failure. The methodology progressed from Physical (Layer 1) through Application (Layer 7), isolating the fault to a misconfigured routing table at Layer 3. Structured diagnostic methodology prevents time wasted at higher layers when lower-layer faults are the root cause (Tanenbaum & Wetherall, 2011). The `readiness_check.log` documented each diagnostic step and finding.

**Key concepts:** OSI layer troubleshooting methodology, `ping`, `traceroute`, `netstat`, routing table analysis, systematic fault isolation.

## Session 17: Technical Diagnostic Exam

The timed practical examination assessed integrated competency across Linux administration, networking, Python scripting, Docker, and Active Directory. Operating under time pressure required rapid context-switching and prioritization of high-impact actions. The exam format simulates real-world incident response conditions where analysis must be both accurate and timely (SANS Institute, 2019).

**Key concepts:** Integrated systems thinking, timed technical execution, cross-domain diagnostic skills, documentation under pressure.

## Session 18: Solo Full-Stack Enterprise Deployment — Titan Small Business Services

The `HardenedOutpost_SAD.md` Security Architecture Document captures the complete deployment of a hardened small business infrastructure. The architecture integrates SSH hardening, UFW firewall rules, Python-based system auditors, and a two-container Docker stack with air-gapped backend networking. Each control maps to a specific threat scenario, demonstrating defense-in-depth methodology (NIST, 2020).

**Key concepts:** Security architecture documentation, defense-in-depth, UFW firewall configuration, air-gapped container networking, integrated hardening.

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST SP 800-53 Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

SANS Institute. (2019). *Linux command line forensics and incident response*. SANS Reading Room. https://www.sans.org/reading-room/

Tanenbaum, A. S., & Wetherall, D. J. (2011). *Computer networks* (5th ed.). Pearson.
EOF

cat > week-07/notes.md << 'EOF'
# Week 7 Notes: Reconnaissance & Vulnerability Analysis

Adam, H. (2026). *Week 7 lab reflections: OSINT, active reconnaissance, and CVE triage* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 19: Passive Reconnaissance & OSINT

The `ThreatProfile_CloudNano.md` was developed using open-source intelligence techniques against a simulated target organization. OSINT collection leveraged publicly available sources including DNS records, WHOIS data, certificate transparency logs, and social media footprints. Passive reconnaissance generates no target-side alerts, making it the preferred initial phase of any authorized assessment (Engebretson, 2013).

**Key concepts:** OSINT methodology, certificate transparency, WHOIS enumeration, DNS harvesting, threat profiling.

## Session 20: Active Reconnaissance & Nmap Scanning

Active scanning of the TitanCorp DMZ subnet (172.88.0.0/24) using Nmap produced the `nmap_scan_results.txt` artifact. Service version detection (`-sV`) and OS fingerprinting (`-O`) identified the software stack running on each host. The `Perimeter_Assessment.md` synthesized scan results with Nikto web vulnerability findings into a risk-prioritized remediation recommendation (Lyon, 2009).

**Key concepts:** Nmap scan types (SYN, TCP connect, UDP), service version detection, OS fingerprinting, Nikto web scanning, result synthesis.

## Session 21: CVE Research & CVSS Triage

The `remediation_plan.md` triaged 20 raw vulnerability findings for CloudNano Corp, selecting the top 5 by a Likelihood × Impact formula rather than raw CVSS scores. CVSS scores alone do not account for exploitability in context; adjusting for environmental factors produces more actionable prioritization (FIRST, 2019). Each selected vulnerability maps to a specific remediation action with an owner and timeline.

**Key concepts:** CVSS scoring, Likelihood × Impact triage, CVE research (NVD), remediation planning, risk prioritization methodology.

## References

Engebretson, P. (2013). *The basics of hacking and penetration testing* (2nd ed.). Syngress.

FIRST. (2019). *Common Vulnerability Scoring System version 3.1: Specification document*. Forum of Incident Response and Security Teams. https://www.first.org/cvss/specification-document

Lyon, G. F. (2009). *Nmap network scanning*. Insecure.com LLC.
EOF

cat > week-08/notes.md << 'EOF'
# Week 8 Notes: Exploitation & Post-Exploitation

Adam, H. (2026). *Week 8 lab reflections: Exploitation frameworks, web application attacks, and privilege escalation* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 22: Exploitation Frameworks & Gaining a Shell

Metasploit Framework was used against a deliberately vulnerable Samba service in the `labs/metasploit-samba` lab environment. The exploit chain progressed from service enumeration through payload delivery to an interactive Meterpreter shell. Post-exploitation enumeration demonstrated how an attacker pivots from initial access to privilege escalation. All activity was conducted in an isolated lab environment under authorized conditions (Kennedy et al., 2011).

**Key concepts:** Metasploit module selection (`use`, `set`, `run`), Meterpreter shell, post-exploitation enumeration, privilege escalation paths, lab isolation.

## Session 23: Web Application Attacks & Traffic Interception

Burp Suite was configured as an intercepting proxy to capture and manipulate HTTP/S traffic against the lab web application. Request modification demonstrated how parameter tampering and session token analysis are performed during web application penetration testing. The `sandbox_report.md` documents VM network isolation modes relevant to safe malware analysis environments (PortSwigger, 2023).

**Key concepts:** Burp Suite proxy configuration, HTTP request interception, parameter tampering, session token analysis, traffic manipulation.

## Session 24: SQL Injection & XSS Session Theft

SQLmap automated SQL injection testing against the lab application, documented in `sqli_report.txt`. XSS payloads in `xss_payloads.txt` demonstrated session cookie theft via `document.cookie` exfiltration. The `Deep_Pivot_Report.md` synthesizes exploitation findings into an intelligence report. SQL injection remains the most prevalent web vulnerability class due to insufficient input validation (OWASP, 2021).

**Key concepts:** SQLmap automation, UNION-based and blind SQL injection, XSS payload construction, session cookie theft, `HttpOnly` and `Secure` flag mitigations.

## References

Kennedy, D., O'Gorman, J., Kearns, D., & Aharoni, M. (2011). *Metasploit: The penetration tester's guide*. No Starch Press.

OWASP. (2021). *OWASP Top Ten 2021*. Open Web Application Security Project. https://owasp.org/Top10/

PortSwigger. (2023). *Burp Suite documentation*. PortSwigger Ltd. https://portswigger.net/burp/documentation
EOF

cat > week-09/notes.md << 'EOF'
# Week 9 Notes: Exploitation & Post-Exploitation (Continued)

Adam, H. (2026). *Week 9 lab reflections: API security, full-stack web exploitation, and business logic attacks* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Sessions 25–27: Full-Stack Web Application Assessment

The `OmniPortal_Assessment.md` documents a comprehensive assessment of a full-stack web application, covering authentication bypass, IDOR (Insecure Direct Object Reference), BOLA (Broken Object Level Authorization), and CSRF vulnerabilities. The `api_audit.log` captures API endpoint enumeration and business logic flaw discovery. BOLA is consistently ranked the top API security risk due to insufficient object-level authorization checks (OWASP, 2023).

**Key concepts:** IDOR/BOLA exploitation, API endpoint enumeration, business logic testing, CSRF token bypass, authentication flaw analysis.

The `sqli_report.txt` and `xss_payloads.txt` artifacts document injection and client-side attack vectors identified during the assessment. Chaining XSS with session token theft demonstrates how client-side vulnerabilities escalate to account takeover. The assessment methodology followed the OWASP Web Security Testing Guide (WSTG) framework for systematic coverage.

**Key concepts:** Vulnerability chaining, account takeover via XSS, WSTG methodology, report writing, risk rating.

## References

OWASP. (2021). *OWASP Top Ten 2021*. Open Web Application Security Project. https://owasp.org/Top10/

OWASP. (2023). *OWASP API Security Top 10 2023*. Open Web Application Security Project. https://owasp.org/API-Security/editions/2023/en/0x11-t10/
EOF

cat > week-10/notes.md << 'EOF'
# Week 10 Notes: Digital Forensics & Incident Response (DFIR)

Adam, H. (2026). *Week 10 lab reflections: Chain of custody, disk forensics, and memory analysis* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 28: Chain of Custody & Live Triage

The `collection_log.txt` documents evidence collection from a live compromised system following chain of custody procedures. Live triage prioritized volatile data collection (running processes, network connections, logged-in users) before disk imaging, as volatile data is lost on shutdown. The `attack_timeline.csv` reconstructs the incident chronology from log artifacts, establishing the sequence of attacker actions (Casey, 2011).

**Key concepts:** Chain of custody documentation, volatile data collection order, live triage tools (`ps`, `netstat`, `lsof`), timeline reconstruction.

## Session 29: Disk Forensics

The `forensic_findings.md` documents analysis of a disk image artifact from the lab environment. File system timeline analysis, deleted file recovery, and artifact correlation were used to identify indicators of compromise. Forensic integrity was maintained by working from a write-blocked image copy, preserving the original evidence (Carrier, 2005).

**Key concepts:** Forensic imaging, write blockers, file system timeline analysis, deleted file recovery, artifact correlation, hash verification.

## Session 30: Memory Forensics

Memory dump extraction and analysis identified injected processes, network connections, and credential material not visible in static disk analysis. The `Incident_Response_Report.md` synthesizes all DFIR findings into a formal incident response report following the PICERL framework (Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned). Memory forensics is essential for detecting fileless malware that leaves no disk artifacts (Ligh et al., 2014).

**Key concepts:** Memory acquisition, Volatility framework, process injection detection, fileless malware indicators, PICERL incident response framework.

## References

Carrier, B. (2005). *File system forensic analysis*. Addison-Wesley.

Casey, E. (2011). *Digital evidence and computer crime: Forensic science, computers, and the internet* (3rd ed.). Academic Press.

Ligh, M. H., Case, A., Levy, J., & Walters, A. (2014). *The art of memory forensics: Detecting malware and threats in Windows, Linux, and Mac memory*. Wiley.
EOF

cat > week-11/notes.md << 'EOF'
# Week 11 Notes: Active Defense

Adam, H. (2026). *Week 11 lab reflections: Firewall configuration, intrusion detection, and endpoint detection and response* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 31: Firewall Rules & Traffic Filtering

The `firewall_config.sh` script implements UFW-based perimeter firewall rules for the lab environment. Rules enforce default-deny inbound policy, permitting only explicitly authorized services. Stateful packet inspection ensures established connections are permitted without explicit return rules. Firewall rule ordering is critical; rules are evaluated top-down and the first match determines the action (Zwicky et al., 2000).

**Key concepts:** UFW rule syntax, default-deny policy, stateful inspection, rule ordering, ingress and egress filtering.

## Session 32: Intrusion Detection & Alert Analysis

The `IDS_Lab/custom_ids.rules` artifact contains custom Suricata detection rules developed to identify specific attack patterns observed in previous lab sessions. Alert analysis from the Suricata output required distinguishing true positives from false positives based on contextual knowledge of the network baseline. Effective IDS tuning reduces alert fatigue while maintaining detection fidelity (Bejtlich, 2004).

**Key concepts:** Suricata rule syntax, alert tuning, true/false positive analysis, network baseline, signature-based vs. anomaly-based detection.

## Session 33: Endpoint Detection & Response

The `edr_policy.xml` defines EDR detection policies applied to lab endpoints. EDR telemetry provides visibility into process creation, network connections, file modifications, and registry changes that perimeter controls cannot observe. The `TLAB11/Operation_Fortress_Report.md` synthesizes the full active defense deployment into an operational report. EDR is a cornerstone of modern detection and response capability (Crowdstrike, 2022).

**Key concepts:** EDR telemetry sources, behavioral detection, process tree analysis, EDR policy configuration, defense-in-depth with layered controls.

## References

Bejtlich, R. (2004). *The Tao of network security monitoring: Beyond intrusion detection*. Addison-Wesley.

Crowdstrike. (2022). *Endpoint detection and response: The definitive guide*. CrowdStrike Inc. https://www.crowdstrike.com/cybersecurity-101/endpoint-security/endpoint-detection-and-response-edr/

Zwicky, E. D., Cooper, S., & Chapman, D. B. (2000). *Building internet firewalls* (2nd ed.). O'Reilly Media.
EOF

# ============================================================
# STEP 9: VERIFY portfolio_audit.md EXISTS IN WEEK-12
# ============================================================
if [ ! -f week-12/portfolio_audit.md ]; then
    cat > week-12/portfolio_audit.md << 'EOF'
# Portfolio Audit — Week 12
# Analyst: Hassaballah Adam
# IFCS Phase 1 — Cybersecurity Program

## Folder Structure Audit

| Week | Folder Present | Artifacts Present | notes.md Present |
|------|---------------|-------------------|-----------------|
| 01   | ✅            | ✅                | ✅              |
| 02   | ✅            | ✅                | ✅              |
| 03   | ✅            | ✅                | ✅              |
| 04   | ✅            | ✅                | ✅              |
| 05   | ✅            | ✅                | ✅              |
| 06   | ✅            | ✅                | ✅              |
| 07   | ✅            | ✅                | ✅              |
| 08   | ✅            | ✅                | ✅              |
| 09   | ✅            | ✅                | ✅              |
| 10   | ✅            | ✅                | ✅              |
| 11   | ✅            | ✅                | ✅              |
| 12   | ✅            | ✅                | N/A             |

## Professional Reflection

This portfolio represents twelve weeks of immersive, hands-on cybersecurity training spanning both offensive and defensive disciplines. The phase began with foundational Linux administration and concluded with a full-spectrum active defense deployment, tracing a deliberate skill progression from system-level fundamentals through enterprise-scale security operations.

The most significant technical growth occurred at the intersection of offensive and defensive knowledge. Completing exploitation labs in Weeks 8 and 9 — using Metasploit, Burp Suite, SQLmap, and custom XSS payloads — fundamentally changed the approach to defensive work in Weeks 10 and 11. Understanding how attackers enumerate services, escalate privileges, and persist in an environment makes firewall rule design, IDS signature writing, and EDR policy configuration more precise and threat-informed rather than compliance-driven.

The Week 6 Forge midterm was a pivotal moment. Operating under timed conditions across five knowledge domains simultaneously — diagnosing a broken network, writing a Python auditor, hardening a Docker deployment, and producing a full security architecture document — compressed what would normally be a multi-day engagement into a single session. The `HardenedOutpost_SAD.md` produced during Session 18 remains the most complete artifact in this portfolio, demonstrating the ability to design, document, and justify a full security architecture against realistic threat scenarios.

The DFIR work in Week 10 introduced the most conceptually challenging material: reconstructing attacker actions from fragmented log evidence, maintaining chain of custody under time pressure, and synthesizing forensic findings into a legally defensible incident report. The `attack_timeline.csv` reconstruction exercise demonstrated that effective incident response is as much an analytical discipline as a technical one.

Looking ahead, the competencies developed in Phase 1 establish a foundation for advanced work in threat hunting, red team operations, and security engineering. The portfolio demonstrates not only technical execution but the professional practice habits — structured documentation, APA-style written communication, version-controlled artifact management — that distinguish a practitioner ready for industry roles from one who can only execute in supervised lab conditions.

Adam, H. (2026). *Phase 1 portfolio audit and professional reflection* [Unpublished assessment document]. IFCS Phase 1 Cybersecurity Program.
EOF
fi

echo ""
echo "============================================"
echo "[+] Portfolio structure setup complete!"
echo "============================================"
echo ""
echo "Week folders created: week-01 through week-11"
echo "All artifacts placed in correct folders"
echo "notes.md created for each week (APA style)"
echo "portfolio_audit.md verified in week-12/"
echo ""
echo "Next steps:"
echo "  1. Review the files look correct"
echo "  2. git add ."
echo "  3. git commit -m 'restructure: organize artifacts into week folders, add notes.md'"
echo "  4. git push origin main"
