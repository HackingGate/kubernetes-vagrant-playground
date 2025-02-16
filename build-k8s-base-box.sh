#!/bin/bash

# Init packer
packer init packer

# Build base box
PACKER_LOG=1 packer build -force packer/base-box.pkr.hcl

# Remove old base box
vagrant box remove k8s-base
