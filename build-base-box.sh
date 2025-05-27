#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Check if distribution is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <distribution> [version]"
  echo "  distribution: k8s, k3s, or k0s"
  echo "  version: Optional version override for k8s/k3s/k0s (default: uses version in packer config)"
  exit 1
fi

DISTRIBUTION=$1
VERSION=$2

# Validate distribution
if [[ ! "$DISTRIBUTION" =~ ^(k8s|k3s|k0s)$ ]]; then
  echo "Error: Distribution must be k8s, k3s, or k0s"
  exit 1
fi

# Check if generic/debian12 box exists
if ! vagrant box list | grep -q "generic/debian12"; then
  echo "generic/debian12 box not found. Adding it now..."
  vagrant box add generic/debian12 --provider=libvirt
else
  echo "generic/debian12 box already exists. Using existing box."
fi

echo "Building $DISTRIBUTION base box..."

# Init packer
packer init "packer/$DISTRIBUTION-base-box.pkr.hcl"
# Build distribution-specific base box with optional version override
if [ -z "$VERSION" ]; then
  packer build -force "packer/$DISTRIBUTION-base-box.pkr.hcl"
else
  packer build -force -var "version=$VERSION" "packer/$DISTRIBUTION-base-box.pkr.hcl"
fi

echo "$DISTRIBUTION base box built successfully!"
