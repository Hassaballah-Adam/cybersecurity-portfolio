# Week 9 Notes: Exploitation & Post-Exploitation (Continued)

Adam, H. (2026). *Week 9 lab reflections: API security, full-stack web exploitation, and business logic attacks* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Sessions 25–27: Full-Stack Web Application Assessment

The `OmniPortal_Assessment.md` documents a comprehensive assessment of a full-stack web application, covering authentication bypass, IDOR (Insecure Direct Object Reference), BOLA (Broken Object Level Authorization), and CSRF vulnerabilities. The `api_audit.log` captures API endpoint enumeration and business logic flaw discovery. BOLA is consistently ranked the top API security risk due to insufficient object-level authorization checks (OWASP, 2023).

**Key concepts:** IDOR/BOLA exploitation, API endpoint enumeration, business logic testing, CSRF token bypass, authentication flaw analysis.

The `sqli_report.txt` and `xss_payloads.txt` artifacts document injection and client-side attack vectors identified during the assessment. Chaining XSS with session token theft demonstrates how client-side vulnerabilities escalate to account takeover. The assessment methodology followed the OWASP Web Security Testing Guide (WSTG) framework for systematic coverage.

**Key concepts:** Vulnerability chaining, account takeover via XSS, WSTG methodology, report writing, risk rating.

## References

OWASP. (2021). *OWASP Top Ten 2021*. Open Web Application Security Project. https://owasp.org/Top10/

OWASP. (2023). *OWASP API Security Top 10 2023*. Open Web Application Security Project. https://owasp.org/API-Security/editions/2023/en/0x11-t10/
