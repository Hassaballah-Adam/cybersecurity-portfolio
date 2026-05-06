 Security Architecture Document
## Titan Small Business Services — HardenedOutpost

**Engineer:** Hassaballah Adam
**Host:** ubuntu-lab
**Date:** 2026-04-24

---

## Phase 1: Perimeter Hardening

### SSH Configuration
- `PermitRootLogin no` — root login disabled to prevent direct root access
- `PasswordAuthentication no` — password login disabled, key-only authentication enforced
- `ed25519` key deployed — modern elliptic curve key for stronger security

### Firewall (UFW)
- Default policy: **deny all incoming** traffic
- Allowed: `22/tcp` (SSH), `8080/tcp` (web service)
- UFW enabled on startup to persist across reboots

---

## Phase 2: Automated Auditors

Two Python auditor scripts were written and deployed to monitor system health:

**sys_auditor.py** — Disk Usage Monitor
- Runs `df -h` to capture disk usage across all mounted filesystems
- Appends timestamped output to `/var/log/sys_audit.log`

**dc_auditor.py** — Domain Controller Connectivity Monitor
- Pings `192.168.128.1` (Domain Controller) 4 times
- Writes `DC is UP` or `DC is DOWN` with timestamp to `/var/log/dc_audit.log`
- Result at time of assessment: **DC is UP**

---

## Phase 3: Docker Stack

A two-container Docker stack was built and deployed entirely from scratch with no internet access (aarch64 architecture).

| Container | Image | Port | Network |
|---|---|---|---|
| skipy_wiki_1 | wiki:local | 8080→80 | frontend |
| skipy_db_1 | db:local | none | backend |

### Network Architecture
- `frontend` — bridge network, externally accessible on port 8080
- `backend` — bridge network with `internal: true` (air-gapped, no external routing)

### Security Note
The database container has no exposed ports and sits on an internal-only network, ensuring it cannot be reached from outside the host — a deliberate defence-in-depth design choice.
