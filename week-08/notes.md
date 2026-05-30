# Week 8 Notes: Exploitation & Post-Exploitation

Adam, H. (2026). *Week 8 lab reflections: Exploitation frameworks, web application attacks, and privilege escalation* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 22: Exploitation Frameworks & Gaining a Shell

Metasploit Framework was used against a deliberately vulnerable Samba service in the `labs/metasploit-samba` lab environment. The exploit chain progressed from service enumeration through payload delivery to an interactive Meterpreter shell. Post-exploitation enumeration demonstrated how an attacker pivots from initial access to privilege escalation. All activity was conducted in an isolated lab environment under authorized conditions (Kennedy et al., 2011).

**Key concepts:** Metasploit module selection (`use`, `set`, `run`), Meterpreter shell, post-exploitation enumeration, privilege escalation paths, lab isolation.

## Session 23: Web Application Attacks & Traffic Interception

Burp Suite was configured as an intercepting proxy to capture and manipulate HTTP/S traffic against the lab web application. Request modification demonstrated how parameter tampering and session token analysis are performed during web application penetration testing. The `sandbox_report.md` documents VM network isolation modes relevant to safe malware analysis environments (PortSwigger, 2023).

**Key concepts:** Burp Suite proxy configuration, HTTP request interception, parameter tampering, session token analysis, traffic manipulation.

## Session 24: SQL Injection & XSS Session Theft

SQLmap automated SQL injection testing against the lab application, documented in `sqli_report.txt`. XSS payloads in `xss_payloads.txt` demonstrated session cookie theft via `document.cookie` exfiltration. The `Deep_Pivot_Report.md` synthesizes exploitation findings into an intelligence report. SQL injection remains the most prevalent web vulnerability class due to insufficient input validation (OWASP, 2021).

**Key concepts:** SQLmap automation, UNION-based and blind SQL injection, XSS payload construction, session cookie theft, `HttpOnly` and `Secure` flag mitigations.

## References

Kennedy, D., O'Gorman, J., Kearns, D., & Aharoni, M. (2011). *Metasploit: The penetration tester's guide*. No Starch Press.

OWASP. (2021). *OWASP Top Ten 2021*. Open Web Application Security Project. https://owasp.org/Top10/

PortSwigger. (2023). *Burp Suite documentation*. PortSwigger Ltd. https://portswigger.net/burp/documentation
