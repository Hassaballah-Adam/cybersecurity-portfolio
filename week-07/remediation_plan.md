# CLOUDNANO REMEDIATION PLAN
**Operator:** ## TOP 5 CRITICAL FIXES
*(From the 20 raw findings, select the 5 that pose the greatest ACTUAL risk. Explain your reasoning.)*

# CloudNano Corp — Vulnerability Remediation Plan
**Analyst:** Lead Security Engineer
**Date:** 2026-04-26
**Scope:** Top 5 actionable findings from 20-item raw scan (Nessus/OpenVAS + Nikto)
**Method:** Risk = Likelihood × Impact — context-weighted, not CVSS-sorted

---

## Selected Vulnerabilities for Immediate Remediation

### 1. Unauthenticated AWS S3 Bucket — Customer PII (CVSS 9.8)
**Justification:** Likelihood is maximum — public S3 buckets are crawled by automated tools within hours, requiring zero authentication. Impact is catastrophic: customer PII exposure triggers mandatory GDPR/CCPA breach notification and irreversible regulatory penalties. Both axes of risk are simultaneously at their ceiling.

### 2. Remote Code Execution — Apache Struts (CVSS 9.8)
**Justification:** This server is internet-facing with mature public exploits available, making likelihood critically high with no network-layer mitigation possible. Impact is total system compromise and a direct pivot point into the internal network.

### 3. SMBv1 Enabled — Internal HR File Server (CVSS 9.0)
**Justification:** EternalBlue exploits for SMBv1 are fully weaponized; any attacker who pivots from the Struts RCE reaches this server immediately. Impact is ransomware propagation across the Windows domain and encryption of sensitive payroll and personnel records.

### 4. SQL Injection — Customer Database Login Portal (CVSS 8.1)
**Justification:** The login page is internet-facing and sqlmap-class automated tools will find and exploit unparameterized queries within minutes. Impact is a full customer database dump and authentication bypass, compounding the PII exposure from the S3 bucket.

### 5. Cross-Site Scripting (XSS) — Customer Support Forum (CVSS 8.8)
**Justification:** The forum is publicly accessible by design, so any registered user can deliver a stored XSS payload with no internal access required. Impact targets customers directly via session hijack and credential theft on the highest-trust surface of the platform.

---

## Deprioritized — CVSS 10.0 Router
Default credentials on the internal router score maximum CVSS but are deprioritized because the air-gapped network eliminates all remote access paths, reducing likelihood to near zero today. Credentials should be rotated in the next maintenance window.
