# 🔐 Cybersecurity Learning Portfolio
### Hassaballah Adam — Offensive & Defensive Security Fundamentals

---

## 👋 About This Repo

This repository documents my journey learning cybersecurity from the ground up — covering everything from Linux fundamentals and Python scripting to active reconnaissance, malware analysis, and infrastructure hardening. It reflects hands-on, practical work across both offensive and defensive disciplines.

---

## 📁 Projects & Reports

### 🛡️ [HardenedOutpost_SAD.md](./HardenedOutpost_SAD.md) — Security Architecture Document
A full security architecture document for **Titan Small Business Services**. Covers SSH hardening, UFW firewall configuration, automated Python auditors, and a two-container Docker stack with air-gapped backend networking.

### 🔍 [Perimeter_Assessment.md](./Perimeter_Assessment.md) — Perimeter Assessment Report
An active reconnaissance and vulnerability assessment against the **TitanCorp** DMZ subnet (`172.88.0.0/24`). Uses Nmap for host discovery and Nikto for web vulnerability scanning, concluding with a risk-prioritised remediation recommendation.

### 🩹 [remediation_plan.md](./remediation_plan.md) — Vulnerability Remediation Plan
A risk-ranked remediation plan for **CloudNano Corp** selecting the top 5 critical vulnerabilities from a 20-item raw scan. Uses the Likelihood × Impact formula rather than raw CVSS scores to prioritise actionable fixes.

### 🧪 [sandbox_report.md](./sandbox_report.md) — Sandbox Detonation Report
A malware analysis lab report examining VM network isolation modes. Demonstrates why Host-Only networking is required for safe malware detonation and the dangers of Bridged mode in a SOC environment.

### 🐍 [dc_auditor.py](./dc_auditor.py) — Domain Controller Auditor
A Python script that pings the Domain Controller and logs `DC is UP` or `DC is DOWN` with a timestamp to `/var/log/dc_audit.log`.

### 🐍 [sys_auditor.py](./sys_auditor.py) — System Auditor
A Python script that captures disk usage via `df -h` and appends timestamped output to `/var/log/sys_audit.log`.

### 🐳 [docker-compose.yml](./docker-compose.yml) — Docker Infrastructure
A two-service Docker stack with a frontend wiki service (port 8080) and an air-gapped backend database service on an internal-only bridge network.

---

## 🗂️ What I've Learned

### 🖥️ Linux & System Administration
- Setting up and managing **Virtual Machines**
- Core terminal commands: `mkdir`, `cd`, `cat`, `nano`, `chmod`
- File permissions, directory structure, and use
