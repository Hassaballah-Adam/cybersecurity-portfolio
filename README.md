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

### 🧪 [sandbox_report.txt](./sandbox_report.txt) — Sandbox Detonation Report
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
- File permissions, directory structure, and user management
- Securing virtual environments from the ground up

### 🐍 Programming & Scripting
- **Python** fundamentals for automation and security tooling
- Writing auditor scripts to monitor system and network health

### 🔧 Version Control
- **Git** — `git init`, `git status`, `git add`, `git commit`, `git push`
- Managing repositories and collaborating via GitHub
- Best practices: `.gitignore`, keeping sensitive files out of version control

### 🔍 Reconnaissance
- **Passive Reconnaissance** — OSINT techniques, Google Dorking, public information gathering
- **Active Reconnaissance** — **Nmap** scanning, port discovery, service enumeration

### ⚔️ Offensive Security
- Introduction to **offensive exploits** — how vulnerabilities are identified and tested
- **SQL Injection** — understanding and simulating database attacks
- Ethical hacking mindset and responsible disclosure principles

### 🛡️ Defensive Security
- **Defensive exploits** — hardening systems against known attack vectors
- VM and server hardening — SSH config, UFW firewall, key-based authentication
- **Malware sandbox analysis** — safe detonation environments and network isolation
- **Social Engineering prevention** — identifying phishing, pretexting, and manipulation tactics

---

## 🛠️ Tools & Technologies

| Category | Tools |
|---|---|
| Scanning & Enumeration | Nmap, Nikto |
| Scripting | Python, Bash |
| Containerisation | Docker, Docker Compose |
| Version Control | Git, GitHub |
| Virtualisation | Virtual Machines (VM) |
| OSINT | Google Dorking |
| Vulnerability Scanning | Nessus/OpenVAS |

---

## 🔗 About Me

I'm actively building a foundation in cybersecurity with a focus on both understanding how attacks work and how to defend against them.

- 🔗 [GitHub](https://github.com/Hassaballah-Adam)

---

> *"To defend a system, you must first understand how it can be broken."*
