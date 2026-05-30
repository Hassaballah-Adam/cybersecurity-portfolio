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
