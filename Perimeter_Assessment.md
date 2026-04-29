# TITANCORP: PERIMETER ASSESSMENT REPORT
**Operator:** **Target Subnet:** 172.88.0.0/24

## PHASE 1: ACTIVE ENUMERATION (NMAP)
*(List the live IPs discovered and their running services/versions)*
* **Host 1 ([172.88.0.10]):** [nginx 1.14.2]
* **Host 2 ([172.88.0.15]):** [Unknown/Filtered (Host is up)]
* **Host 3 ([172.88.0.20]):** [Apache httpd 2.4.6]

## PHASE 2: VULNERABILITY AUDIT (NIKTO)
*(Run Nikto against the TWO web servers discovered above. List one major finding for each.)*
* **Web Server 1 Finding:** [Missing anti-clickjacking X-Frame-Options header (Tool: Nikto).]
* **Web Server 2 Finding:** [HTTP TRACE method is active, suggesting vulnerability to XST (Tool: Nikto).]

## PHASE 3: RISK TRIAGE
*(Review your findings. Identify the SINGLE highest-risk vulnerability across the entire DMZ. Justify why it is the top priority using the Likelihood x Impact formula.)*

* **Top Priority Remediation:** [Disable HTTP TRACE method on 172.88.0.20 (Apache).]
* **Justification:** [This is the highest risk because the likelihood of exploitation is high due to automated scripts, and the impact is significant as it allows attackers to steal sensitive session cookies even if they are marked as HttpOnly.]
