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
