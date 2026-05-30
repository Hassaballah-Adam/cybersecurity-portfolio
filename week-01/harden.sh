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
