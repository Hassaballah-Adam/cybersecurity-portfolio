# Security Architecture Document
## Titan Small Business Services - HardenedOutpost
**Engineer:** skipy | **Host:** ubuntu-lab | **Date:** 2026-04-24

## Phase 1: Perimeter Hardening
SSH: PermitRootLogin no, PasswordAuthentication no, ed25519 key deployed
UFW: default deny incoming, allow 22/tcp, allow 8080/tcp, enabled on startup

## Phase 2: Auditors
sys_auditor.py: runs df -h, writes to /var/log/sys_audit.log
dc_auditor.py: pings 192.168.128.1 x4, writes DC is UP/DOWN to /var/log/dc_audit.log
Result: DC is UP

## Phase 3: Docker Stack
wiki:local - port 8080->80, frontend network
db:local - no ports, backend network (internal: true = air-gapped)
Containers: skipy_wiki_1 Up, skipy_db_1 Up
Networks: skipy_frontend (bridge), skipy_backend (bridge/internal)
Note: Images built locally from scratch (aarch64, no internet access)
