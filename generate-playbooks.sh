#!/bin/bash
set -e  # Exit immediately if a command exits with non-zero status

# Function to generate playbooks from templates
generate_playbooks() {
  local dist=$1
  
  echo "Generating playbooks for $dist..."
  
  # Create directory if it doesn't exist
  mkdir -p "$dist"
  
  # Replace placeholders in templates
  sed -e "s/{{ distribution }}/$dist/g" \
      common/base-playbook.template.yml > "$dist/base-playbook.yml"
  
  sed -e "s/{{ distribution }}/$dist/g" \
      common/control-playbook.template.yml > "$dist/control-playbook.yml"
  
  sed -e "s/{{ distribution }}/$dist/g" \
      common/worker-playbook.template.yml > "$dist/worker-playbook.yml"
  
  echo "Generated playbooks for $dist"
}

# Generate playbooks for each distribution
generate_playbooks "k8s"
generate_playbooks "k3s"
generate_playbooks "k0s"

echo "All playbooks generated successfully!"
