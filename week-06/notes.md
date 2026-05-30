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
