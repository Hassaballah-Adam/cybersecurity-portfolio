# OMNI-PORTAL ASSESSMENT REPORT
**Operator:** **Deadline:** April 5 @ 11:59 PM 

## PHASE 1: AUTH BYPASS (SQLi)
* **Payload Used:** [' OR 1=1 --]
* **Result:** Successfully bypassed login and obtained 'auth_token' cookie.

## PHASE 2: CLIENT-SIDE HIJACK (XSS)
* **Stored XSS Payload:** [<script>alert(document.cookie)</script>]
* **Secret Cookie Captured:** [SUPPORT_TIER_1_SECRET_TOKEN]

## PHASE 3: API ENUMERATION (BOLA)
* **Insecure Order ID:** [501]
* **Confidential Data Leaked:** [Order 501 - Confidential Server Lease - $15,000.00]

## PHASE 4: THE REMEDIATION
* **Fix for SQLi:** Use parameterized queries (prepared statements) so user input is never concatenated directly into SQL strings.
* **Fix for XSS:** HTML-encode all user input before rendering it on the page so it is treated as text, not executable code.
* **Fix for API BOLA:** Verify the authenticated user owns the requested order ID before returning data. Check that the order's user_id matches the logged-in session.
