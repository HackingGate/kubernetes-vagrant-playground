# Kubernetes Cluster Playground on Vagrant VM

[![Lint](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml/badge.svg)](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml)

This repository contains Ansible playbooks and configuration for setting up Kubernetes clusters using Vagrant with libvirt provider. It supports three different Kubernetes distributions:

- **k8s**: Standard Kubernetes distribution
- **k3s**: Lightweight Kubernetes distribution by Rancher
- **k0s**: Zero-friction Kubernetes distribution by Mirantis

Each distribution creates a three-node cluster with one control plane and two worker nodes, all running on Debian 12.

## Prerequisites

- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Vagrant](https://developer.hashicorp.com/vagrant/install)
- [Vagrant-libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/)

## Architecture

Each cluster consists of:

- 1 control plane node (2GB RAM, 2 CPUs)
- 2 worker nodes (2GB RAM, 2 CPUs each)
- Private network: 192.168.121.0/24
- Pod network: 10.244.0.0/16

## Setup

First, run the setup script to generate all the necessary configuration files:

```bash
./setup.sh
```

## Usage

### Build Base Box with Packer

Choose which Kubernetes distribution you want to use:

```bash
# For standard Kubernetes (k8s)
./build-base-box.sh k8s

# For k3s
./build-base-box.sh k3s

# For k0s
./build-base-box.sh k0s

# Optionally specify a version
./build-base-box.sh k8s v1.31
```

This command will:

1. Download the Debian 12 base box
2. Install system updates and required packages
3. Install containerd container runtime
4. Install the selected Kubernetes distribution
5. Package the resulting VM into a new Vagrant box

### Create the Virtual Machines and Provision the Kubernetes Cluster

```bash
# For standard Kubernetes (k8s)
./run-cluster.sh k8s up

# For k3s
./run-cluster.sh k3s up

# For k0s
./run-cluster.sh k0s up
```

This command will:

1. Create three virtual machines using the appropriate base box
2. Initialize the Kubernetes control plane
3. Set up pod networking
4. Generate join tokens for worker nodes
5. Join worker nodes to the cluster
6. Install Helm package manager on the control plane

### Access and Verify the Cluster

The kubeconfig file is automatically configured on the control plane node. To access and verify the cluster:

1. SSH into the control plane:

   ```bash
   # For standard Kubernetes (k8s)
   vagrant ssh k8s-control

   # For k3s
   cd k3s && vagrant ssh k3s-control

   # For k0s
   cd k0s && vagrant ssh k0s-control
   ```

2. Verify cluster status:

   ```bash
   # Check node status
   kubectl get nodes

   # View running system pods
   kubectl get pods -A
   ```

You should see three nodes (one control plane and two workers) in Ready state.

### Destroy the Cluster

When you're done experimenting, you can destroy all VMs:

```bash
# For standard Kubernetes (k8s)
./run-cluster.sh k8s destroy

# For k3s
./run-cluster.sh k3s destroy

# For k0s
./run-cluster.sh k0s destroy
```

### Remove Base Boxes

```bash
# For standard Kubernetes (k8s)
vagrant box remove k8s-base
rm -rf output-k8s-base

# For k3s
vagrant box remove k3s-base
rm -rf output-k3s-base

# For k0s
vagrant box remove k0s-base
rm -rf output-k0s-base
```

## Network Configuration

For all distributions:

- Control plane: 192.168.121.10
- Worker 1: 192.168.121.11
- Worker 2: 192.168.121.12

## Comparison of Kubernetes Distributions

### k8s (Standard Kubernetes)
- Full-featured Kubernetes distribution
- Requires more resources
- More complex setup
- Suitable for production-like environments

### k3s (Rancher)
- Lightweight Kubernetes distribution
- Single binary installation
- Lower resource requirements
- Suitable for edge computing, IoT, and development environments

### k0s (Mirantis)
- Zero-friction Kubernetes distribution
- Single binary, no dependencies
- Minimal resource footprint
- Suitable for any environment, from edge to cloud

## License

See [LICENSE](LICENSE) file.
