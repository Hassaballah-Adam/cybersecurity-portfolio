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
