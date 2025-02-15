# Kubernetes Cluster Playground on Vagrant VM

[![Lint](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml/badge.svg)](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml)

This repository contains Ansible playbooks and configuration for setting up a Kubernetes cluster using Vagrant.

## Usage

### Create the Virtual Machines and Provision the Kubernetes Cluster

```bash
vagrant up
```

This command will:

1. Create the virtual machines
2. Install containerd runtime
3. Install Kubernetes components
4. Initialize the control plane
5. Join worker nodes to the cluster
6. Install Helm package manager

### Verify Cluster Status

SSH into the control plane node and check the cluster status:

```bash
vagrant ssh k8s-control
kubectl get nodes
```

### Destroy the Cluster

When you're done experimenting, you can destroy all VMs:

```bash
vagrant destroy
```
