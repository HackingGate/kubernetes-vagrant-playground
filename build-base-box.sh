#!/bin/bash
# Init packer
packer init packer
# Build base box
packer build packer/base-box.pkr.hcl
# Remove old base box
vagrant box remove k8s-base
