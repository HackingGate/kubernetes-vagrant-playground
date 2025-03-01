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

echo "Setup completed successfully!"
echo ""
echo "To build a base box for a specific distribution:"
echo "  ./build-base-box.sh <distribution> [version]"
echo "  Example: ./build-base-box.sh k8s"
echo "  Example: ./build-base-box.sh k3s v1.31"
echo ""
echo "To run a cluster for a specific distribution:"
echo "  ./run-cluster.sh <distribution> [command]"
echo "  Example: ./run-cluster.sh k8s up"
echo "  Example: ./run-cluster.sh k3s destroy"
echo ""
echo "Available distributions: k8s, k3s, k0s"
