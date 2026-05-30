# Week 2 Notes: Networking & Protocol Analysis

Adam, H. (2026). *Week 2 lab reflections: OSI model, subnetting, and protocol interrogation* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 4: OSI Model & TCP/IP Fundamentals

The OSI model was applied practically through Wireshark packet capture analysis. Observing a TLS 1.3 handshake at the session layer (Layer 5) and transport layer (Layer 4) provided a concrete illustration of abstract protocol concepts. TLS 1.3 enforces ephemeral key exchange, eliminating static RSA key negotiation and ensuring Perfect Forward Secrecy (Rescorla, 2018). The absence of a separate certificate verify message in TLS 1.3 compared to TLS 1.2 demonstrated the protocol's efficiency improvements.

**Key concepts:** OSI layers, TCP three-way handshake, TLS 1.3 handshake, Wireshark filters, cipher suite negotiation.

## Session 5: IP Subnetting & CIDR Notation

Subnetting the TitanCorp 172.16.0.0/16 network into functional VLANs demonstrated how network segmentation limits lateral movement during a breach. The DMZ was allocated a /28 (14 usable hosts) to minimize the external attack surface, while workstations received a /23 to accommodate growth. CIDR notation and binary subnet math were practiced to internalize the relationship between prefix length and host capacity (Tanenbaum & Wetherall, 2011).

**Key concepts:** CIDR notation, subnet mask calculation, broadcast addresses, VLAN segmentation, network isolation.

## Session 6: DNS & Protocol Interrogation

A DNS zone transfer (AXFR) against the lab domain succeeded, exposing the full internal DNS record set. This misconfiguration is a critical information disclosure vulnerability; in a real engagement it would reveal the complete internal network topology to an attacker. `dig`, `nslookup`, and `netstat` were used to enumerate services and identify exposed ports (Zalewski, 2012).

**Key concepts:** DNS AXFR zone transfer, `dig` and `nslookup` usage, port enumeration with `netstat`, DNS security misconfigurations.

## References

Rescorla, E. (2018). *The Transport Layer Security (TLS) Protocol Version 1.3* (RFC 8446). Internet Engineering Task Force. https://doi.org/10.17487/RFC8446

Tanenbaum, A. S., & Wetherall, D. J. (2011). *Computer networks* (5th ed.). Pearson.

Zalewski, M. (2012). *The tangled web: A guide to securing modern web applications*. No Starch Press.
