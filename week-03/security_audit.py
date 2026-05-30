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
