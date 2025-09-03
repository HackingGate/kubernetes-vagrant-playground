#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Check if distribution is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <distribution> [command]"
  echo "  distribution: k8s, k3s, or k0s"
  echo "  command: Optional Vagrant command (default: up)"
  exit 1
fi

DISTRIBUTION=$1
COMMAND=${2:-up}

# Validate distribution
if [[ ! "$DISTRIBUTION" =~ ^(k8s|k3s|k0s)$ ]]; then
  echo "Error: Distribution must be k8s, k3s, or k0s"
  exit 1
fi

echo "Running 'vagrant $COMMAND' for $DISTRIBUTION cluster..."

# Change to the distribution directory
cd "$DISTRIBUTION" || {
  echo "Error: $DISTRIBUTION directory not found"
  exit 1
}

# Run Vagrant command
vagrant "$COMMAND"

echo "Vagrant $COMMAND completed for $DISTRIBUTION cluster"
