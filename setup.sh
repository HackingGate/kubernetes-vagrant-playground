#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

echo "Setting up Kubernetes Vagrant Playground..."

# Generate Vagrantfiles
echo "Generating Vagrantfiles..."
./generate-vagrantfile.sh

# Generate Playbooks
echo "Generating Playbooks..."
./generate-playbooks.sh

# Generate Packer Configurations
echo "Generating Packer Configurations..."
./generate-packer-configs.sh
