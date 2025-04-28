#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Check if distribution is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <distribution> [version]"
  echo "  distribution: common, k8s, k3s, or k0s"
  echo "  version: Optional version override for k8s/k3s/k0s (default: uses version in packer config)"
  exit 1
fi

DISTRIBUTION=$1
VERSION=$2

# Validate distribution
if [[ ! "$DISTRIBUTION" =~ ^(common|k8s|k3s|k0s)$ ]]; then
  echo "Error: Distribution must be common, k8s, k3s, or k0s"
  exit 1
fi

# Check if building a distribution-specific box and common box exists
if [[ "$DISTRIBUTION" != "common" ]]; then
  # Check if common-base box exists
  if ! vagrant box list | grep -q "common-base"; then
    echo "Error: common-base box not found. Please build it first with: $0 common"
    exit 1
  fi
fi

echo "Building $DISTRIBUTION base box..."

# Init packer
if [[ "$DISTRIBUTION" == "common" ]]; then
  packer init "packer/common-base-box.pkr.hcl"
  
  # Build common base box (no version parameter needed)
  packer build -force "packer/common-base-box.pkr.hcl"
else
  packer init "packer/$DISTRIBUTION-base-box.pkr.hcl"
  
  # Build distribution-specific base box with optional version override
  if [ -z "$VERSION" ]; then
    packer build -force "packer/$DISTRIBUTION-base-box.pkr.hcl"
  else
    packer build -force -var "version=$VERSION" "packer/$DISTRIBUTION-base-box.pkr.hcl"
  fi
fi

echo "$DISTRIBUTION base box built successfully!"
