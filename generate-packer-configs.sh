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
      packer/base-box.template.pkr.hcl > "packer/$dist-base-box.pkr.hcl"
  
  echo "Generated packer/$dist-base-box.pkr.hcl"
}

# Get latest stable k8s version
K8S_VERSION=$(fetch_latest_k8s_version)
echo "Using latest stable Kubernetes version: $K8S_VERSION"

# Generate Packer configurations for each distribution
generate_packer_config "k8s" "$K8S_VERSION"
generate_packer_config "k3s" "$K8S_VERSION"
generate_packer_config "k0s" "$K8S_VERSION"

echo "All Packer configurations generated successfully!"
