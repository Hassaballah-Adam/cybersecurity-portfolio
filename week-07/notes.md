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
