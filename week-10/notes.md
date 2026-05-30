# Week 10 Notes: Digital Forensics & Incident Response (DFIR)

Adam, H. (2026). *Week 10 lab reflections: Chain of custody, disk forensics, and memory analysis* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 28: Chain of Custody & Live Triage

The `collection_log.txt` documents evidence collection from a live compromised system following chain of custody procedures. Live triage prioritized volatile data collection (running processes, network connections, logged-in users) before disk imaging, as volatile data is lost on shutdown. The `attack_timeline.csv` reconstructs the incident chronology from log artifacts, establishing the sequence of attacker actions (Casey, 2011).

**Key concepts:** Chain of custody documentation, volatile data collection order, live triage tools (`ps`, `netstat`, `lsof`), timeline reconstruction.

## Session 29: Disk Forensics

The `forensic_findings.md` documents analysis of a disk image artifact from the lab environment. File system timeline analysis, deleted file recovery, and artifact correlation were used to identify indicators of compromise. Forensic integrity was maintained by working from a write-blocked image copy, preserving the original evidence (Carrier, 2005).

**Key concepts:** Forensic imaging, write blockers, file system timeline analysis, deleted file recovery, artifact correlation, hash verification.

## Session 30: Memory Forensics

Memory dump extraction and analysis identified injected processes, network connections, and credential material not visible in static disk analysis. The `Incident_Response_Report.md` synthesizes all DFIR findings into a formal incident response report following the PICERL framework (Preparation, Identification, Containment, Eradication, Recovery, Lessons Learned). Memory forensics is essential for detecting fileless malware that leaves no disk artifacts (Ligh et al., 2014).

**Key concepts:** Memory acquisition, Volatility framework, process injection detection, fileless malware indicators, PICERL incident response framework.

## References

Carrier, B. (2005). *File system forensic analysis*. Addison-Wesley.

Casey, E. (2011). *Digital evidence and computer crime: Forensic science, computers, and the internet* (3rd ed.). Academic Press.

Ligh, M. H., Case, A., Levy, J., & Walters, A. (2014). *The art of memory forensics: Detecting malware and threats in Windows, Linux, and Mac memory*. Wiley.
