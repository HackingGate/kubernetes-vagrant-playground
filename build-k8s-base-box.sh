#!/bin/bash

# Init packer
packer init packer

# Build base box
packer build -force packer/base-box.pkr.hcl
