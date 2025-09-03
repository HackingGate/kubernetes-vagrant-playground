#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Function to generate Vagrantfile from template
generate_vagrantfile() {
  local dist=$1
  local prefix=$2
  local box_name="${prefix}-base"
  
  echo "Generating Vagrantfile for $dist..."
  
  # Create directory if it doesn't exist
  mkdir -p "$dist"
  
  # Replace placeholders in template
  sed -e "s/{{ prefix }}/$prefix/g" \
      -e "s/{{ box_name }}/$box_name/g" \
      common/Vagrantfile.template > "$dist/Vagrantfile"
  
  echo "Generated $dist/Vagrantfile"
}

# Generate Vagrantfiles for each distribution
generate_vagrantfile "k8s" "k8s"
generate_vagrantfile "k3s" "k3s"
generate_vagrantfile "k0s" "k0s"

echo "All Vagrantfiles generated successfully!"
