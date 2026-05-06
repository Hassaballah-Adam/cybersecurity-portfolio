# Sandbox Detonation Report
**Analyst:** Hassaballah Adam  
**Session:** 10  
**Purpose:** Safe malware analysis using isolated VM networking modes

---

## Findings

### Question 1: Did the ping to google.com succeed or fail in Host-Only mode?

**Result: Failed**

When attempting to ping google.com, the system returned `temporary failure in name resolution`. This confirms that a Host-Only sandbox cannot connect to external DNS servers — the VM is fully isolated from the internet, which is the expected and desired behaviour for safe malware detonation.

---

### Question 2: Why must a SOC analyst NEVER use Bridged mode when detonating unknown malware?

**Answer:**

Bridged mode is dangerous for malware analysis because it places the VM directly on the host's physical network. This gives the malware the same network access as any physical device on the LAN, allowing it to:

- Perform network discovery to identify other devices on the local network
- Attempt lateral movement to infect physical machines outside the virtual environment
- Exfiltrate data through the host's real network interface

Host-Only mode eliminates this risk by creating a completely isolated virtual network that has no routing path to the physical LAN or the internet.

---

## Key Takeaway

> Network isolation is the first and most critical control in any malware analysis environment. Bridged mode should never be used with unknown or potentially malicious samples.

