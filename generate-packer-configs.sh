#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Function to fetch latest stable k8s version
fetch_latest_k8s_version() {
  # Get latest stable version from GitHub API
  local latest_version=$(curl -s https://api.github.com/repos/kubernetes/kubernetes/releases | grep "tag_name" | grep -v "alpha\|beta\|rc" | head -n 1 | cut -d '"' -f 4)
  
  # Extract only major.minor version (removing patch version)
  local major_minor_version=$(echo "$latest_version" | cut -d. -f1-2)
  
  echo "$major_minor_version"
}

# Function to fetch latest stable k3s version
fetch_latest_k3s_version() {
  # Get latest stable version from GitHub API
  local latest_version=$(curl -s https://api.github.com/repos/k3s-io/k3s/releases | grep "tag_name" | grep -v "alpha\|beta\|rc" | head -n 1 | cut -d '"' -f 4)
  
  # Extract only major.minor version (removing v prefix and patch version)
  local major_minor_version=$(echo "$latest_version" | sed 's/^v//' | cut -d. -f1-2)
  
  echo "$major_minor_version"
}

# Function to fetch latest stable k0s version
fetch_latest_k0s_version() {
  # Get latest stable version from k0s API
  local latest_version=$(curl -sSLf "https://docs.k0sproject.io/stable.txt")
  
  # Extract only major.minor version (removing v prefix and patch version)
  local major_minor_version=$(echo "$latest_version" | sed 's/^v//' | cut -d. -f1-2)
  
  echo "$major_minor_version"
}

# Function to generate Packer configurations from template
generate_packer_config() {
  local dist=$1
  local version=$2
  
  echo "Generating Packer configuration for $dist..."
  
  # Create directory if it doesn't exist
  mkdir -p "packer/$dist"
  
  # Replace placeholders in template
  sed -e "s/{{ distribution }}/$dist/g" \
      -e "s/{{ version }}/$version/g" \
      packer/distribution-base-box.template.pkr.hcl > "packer/$dist-base-box.pkr.hcl"
  
  echo "Generated packer/$dist-base-box.pkr.hcl"
}

# Get latest stable versions for each distribution
K8S_VERSION=$(fetch_latest_k8s_version)
K3S_VERSION=$(fetch_latest_k3s_version)
K0S_VERSION=$(fetch_latest_k0s_version)

echo "Using latest stable Kubernetes versions:"
echo "- k8s: $K8S_VERSION"
echo "- k3s: $K3S_VERSION"
echo "- k0s: $K0S_VERSION"

# Generate Packer configurations for each distribution
generate_packer_config "k8s" "$K8S_VERSION"
generate_packer_config "k3s" "$K3S_VERSION"
generate_packer_config "k0s" "$K0S_VERSION"

echo "All Packer configurations generated successfully!"

echo "Setup completed successfully!"
echo ""
echo "To build a base box for a specific distribution:"
echo "  ./build-base-box.sh <distribution> [version]"
echo "  Example: ./build-base-box.sh k8s"
echo "  Example: ./build-base-box.sh k3s ${K3S_VERSION}"
echo ""
echo "To run a cluster for a specific distribution:"
echo "  ./run-cluster.sh <distribution> [command]"
echo "  Example: ./run-cluster.sh k8s up"
echo "  Example: ./run-cluster.sh k3s destroy"
echo ""
echo "Available distributions: k8s, k3s, k0s"
