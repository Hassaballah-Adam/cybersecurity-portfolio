# Week 4 Notes: Docker & Containers

Adam, H. (2026). *Week 4 lab reflections: Container architecture, secure Dockerfile design, and multi-service deployment* [Unpublished session notes]. IFCS Phase 1 Cybersecurity Program.

## Session 10: Virtualization Concepts & Multi-Container Architecture

Docker's layered filesystem and namespace-based isolation were examined in the context of security. Containers share the host kernel, which distinguishes them from virtual machines and introduces different attack surface considerations. The `docker-compose.yml` multi-container architecture separates services by function, enforcing least-privilege network access through defined networks (Turnbull, 2016).

**Key concepts:** Container vs. VM isolation, Docker namespaces and cgroups, multi-container architecture, service separation, Docker networks.

## Session 11: Secure Container Configuration

The hardened `Dockerfile` applies several security best practices: running as a non-root user via `USER appuser`, minimizing the installed package footprint with `--no-install-recommends`, removing the apt cache post-installation, and using the exec form of `ENTRYPOINT` to prevent shell injection. Running containers as root is a leading cause of container escape vulnerabilities (Docker, 2023).

**Key concepts:** Non-root container execution, minimal base images, layer caching, `ENTRYPOINT` exec form, image labeling.

## Session 12: Docker Compose Deployment — The Conductor & the Fleet

The Conductor & Fleet deployment pattern uses Nginx as a reverse proxy (conductor) fronting application containers (fleet), with the database isolated on an internal-only network. The `internal: true` flag on the backend network prevents direct external routing, implementing network segmentation at the container level. Health checks ensure the conductor only routes traffic to healthy fleet containers (Turnbull, 2016).

**Key concepts:** Reverse proxy pattern, internal Docker networks, health checks, secrets management, service restart policies.

## References

Docker. (2023). *Docker security documentation*. Docker Inc. https://docs.docker.com/engine/security/

Turnbull, J. (2016). *The Docker book: Containerization is the new virtualization*. James Turnbull.
