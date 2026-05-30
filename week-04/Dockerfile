# S11 Lab: Secure Container Configuration
# Analyst: Hassaballah Adam
# Date: 2026-02-04

FROM ubuntu:22.04

# Security: run as non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup -s /bin/false appuser

# Security: avoid running apt as root beyond setup
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application files
COPY --chown=appuser:appgroup . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Security: drop to non-root user
USER appuser

# Security: expose only required port
EXPOSE 8080

# Security: use exec form to avoid shell injection
ENTRYPOINT ["python3", "app.py"]

# Security labels
LABEL maintainer="hadam@titan.local"
LABEL version="1.0"
LABEL security.hardened="true"
