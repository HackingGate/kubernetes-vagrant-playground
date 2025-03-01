#!/bin/bash

# Check if distribution is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <distribution> [version]"
  echo "  distribution: k8s, k3s, or k0s"
  echo "  version: Optional version override (default: uses version in packer config)"
  exit 1
fi

DISTRIBUTION=$1
VERSION=$2

# Validate distribution
if [[ ! "$DISTRIBUTION" =~ ^(k8s|k3s|k0s)$ ]]; then
  echo "Error: Distribution must be k8s, k3s, or k0s"
  exit 1
fi

echo "Building $DISTRIBUTION base box..."

# Init packer
packer init packer

# Build base box with optional version override
if [ -z "$VERSION" ]; then
  packer build -force "packer/$DISTRIBUTION-base-box.pkr.hcl"
else
  packer build -force -var "version=$VERSION" "packer/$DISTRIBUTION-base-box.pkr.hcl"
fi

echo "$DISTRIBUTION base box built successfully!"
