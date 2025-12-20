#!/bin/bash
set -e

# Check for required argument
if [ $# -ne 1 ]; then
    echo "Usage: sudo $0 <server|agent>"
    exit 1
fi

ROLE="$1"

if [ "$ROLE" != "server" ] && [ "$ROLE" != "agent" ]; then
    echo "Invalid role: $ROLE. Must be 'server' or 'agent'."
    exit 1
fi

# Create k3s config directory if missing
sudo mkdir -p /etc/rancher/k3s

# Create registries.yaml (all nodes)
sudo tee /etc/rancher/k3s/registries.yaml >/dev/null <<'EOF'
mirrors:
  cr.fluentbit.io:
  cr.smallstep.com:
  cr.step.sm:
  docker.io:
  ecr-public.aws.com:
  gcr.io:
  ghcr.io:
  mirror.gcr.io:
  oci.external-secrets.io:
  public.ecr.aws:
  quay.io:
  registry.k8s.io:
EOF

echo "Created /etc/rancher/k3s/registries.yaml"

# If server, create config.yaml with embedded registry
if [ "$ROLE" == "server" ]; then
    sudo tee /etc/rancher/k3s/config.yaml >/dev/null <<'EOF'
embedded-registry: true
EOF
    echo "Created /etc/rancher/k3s/config.yaml (embedded-registry enabled)"
fi

echo "Done. Changes will take effect on next service start or node reboot."
