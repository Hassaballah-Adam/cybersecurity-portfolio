# Week 11 Notes: Active Defense

Adam, H. (2026). *Week 11 lab reflections: Firewall configuration, intrusion detection, and endpoint detection and response* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 31: Firewall Rules & Traffic Filtering

The `firewall_config.sh` script implements UFW-based perimeter firewall rules for the lab environment. Rules enforce default-deny inbound policy, permitting only explicitly authorized services. Stateful packet inspection ensures established connections are permitted without explicit return rules. Firewall rule ordering is critical; rules are evaluated top-down and the first match determines the action (Zwicky et al., 2000).

**Key concepts:** UFW rule syntax, default-deny policy, stateful inspection, rule ordering, ingress and egress filtering.

## Session 32: Intrusion Detection & Alert Analysis

The `IDS_Lab/custom_ids.rules` artifact contains custom Suricata detection rules developed to identify specific attack patterns observed in previous lab sessions. Alert analysis from the Suricata output required distinguishing true positives from false positives based on contextual knowledge of the network baseline. Effective IDS tuning reduces alert fatigue while maintaining detection fidelity (Bejtlich, 2004).

**Key concepts:** Suricata rule syntax, alert tuning, true/false positive analysis, network baseline, signature-based vs. anomaly-based detection.

## Session 33: Endpoint Detection & Response

The `edr_policy.xml` defines EDR detection policies applied to lab endpoints. EDR telemetry provides visibility into process creation, network connections, file modifications, and registry changes that perimeter controls cannot observe. The `TLAB11/Operation_Fortress_Report.md` synthesizes the full active defense deployment into an operational report. EDR is a cornerstone of modern detection and response capability (Crowdstrike, 2022).

**Key concepts:** EDR telemetry sources, behavioral detection, process tree analysis, EDR policy configuration, defense-in-depth with layered controls.

## References

Bejtlich, R. (2004). *The Tao of network security monitoring: Beyond intrusion detection*. Addison-Wesley.

Crowdstrike. (2022). *Endpoint detection and response: The definitive guide*. CrowdStrike Inc. https://www.crowdstrike.com/cybersecurity-101/endpoint-security/endpoint-detection-and-response-edr/

Zwicky, E. D., Cooper, S., & Chapman, D. B. (2000). *Building internet firewalls* (2nd ed.). O'Reilly Media.
