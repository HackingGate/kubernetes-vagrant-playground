# Kubernetes Cluster Playground on Vagrant VM

[![Lint](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml/badge.svg)](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml)

This repository contains Ansible playbooks and configuration for setting up a Kubernetes cluster using Vagrant with libvirt provider. It creates a three-node cluster with one control plane and two worker nodes, all running on Debian 12.

## Prerequisites

- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Vagrant](https://developer.hashicorp.com/vagrant/install)
- [Vagrant-libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/)

## Architecture

The cluster consists of:
- 1 control plane node (2GB RAM, 2 CPUs)
- 2 worker nodes (2GB RAM, 2 CPUs each)
- Private network: 192.168.121.0/24
- Pod network: 10.244.0.0/16

## Usage

### Build k8s-base box with Packer

```bash
./build-k8s-base-box.sh
```

This command will:
1. Download the Debian 12 base box
2. Install system updates and required packages
3. Install containerd container runtime
4. Install Kubernetes components (kubeadm, kubelet, kubectl)
5. Package the resulting VM into a new Vagrant box named 'k8s-base'

### Create the Virtual Machines and Provision the Kubernetes Cluster

```bash
vagrant up
```

This command will:
1. Create three virtual machines using the k8s-base box
2. Initialize the Kubernetes control plane on k8s-control
3. Set up pod networking
4. Generate join tokens for worker nodes
5. Join worker nodes to the cluster
6. Install Helm package manager on the control plane

### Access and Verify the Cluster

The kubeconfig file is automatically configured on the control plane node. To access and verify the cluster:

1. SSH into the control plane:
   ```bash
   vagrant ssh k8s-control
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
vagrant destroy -f
```

## Network Configuration

- Control plane: 192.168.121.10
- Worker 1: 192.168.121.11
- Worker 2: 192.168.121.12

## License

See [LICENSE](LICENSE) file.
