#!/bin/bash

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

# Generate Packer configurations for each distribution
generate_packer_config "k8s" "v1.32"
generate_packer_config "k3s" "v1.32"
generate_packer_config "k0s" "v1.32"

echo "All Packer configurations generated successfully!"
