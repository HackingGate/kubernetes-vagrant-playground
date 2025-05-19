# Kubernetes Cluster Playground on Vagrant VM

[![Lint](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml/badge.svg)](https://github.com/HackingGate/kubernetes-vagrant-playground/actions/workflows/lint.yml)

This repository contains Ansible playbooks and configuration for setting up a Kubernetes cluster using Vagrant with libvirt provider. It creates a three-node cluster with one control plane and two worker nodes, all running on Debian 12.

## Prerequisites

- [libvirt for Ubuntu](https://documentation.ubuntu.com/server/how-to/virtualisation/libvirt/index.html)
- [libvrit for Fedora](https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started)
- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- [Vagrant](https://developer.hashicorp.com/vagrant/install)
- [QEMU](https://www.qemu.org/download/#linux)
- [Vagrant-libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/)

For Ubuntu:

```bash
sudo apt update
sudo apt install -y qemu-system libvirt-dev virt-manager qemu-efi libvirt-daemon-system ebtables libguestfs-tools ruby-fog-libvirt
sudo adduser $USER libvirt
# Homebrew packages for HashiCorp will not receive updates due to BUSL, use apt instead
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vagrant packer
vagrant plugin install vagrant-libvirt
sudo apt install pipx
pipx ensurepath
pipx install --include-deps ansible
```

For Fedora:

```bash
sudo dnf install @virtualization libvirt-devel virt-manager qemu-efi
sudo adduser $USER libvirt
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install vagrant packer
vagrant plugin install vagrant-libvirt
sudo dnf -y install pipx
pipx ensurepath
pipx install --include-deps ansible
```

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

### Remove k8s-base box

```bash
vagrant box remove k8s-base
rm -rf output-k8s-base
```

## Network Configuration

- Control plane: 192.168.121.10
- Worker 1: 192.168.121.11
- Worker 2: 192.168.121.12

## License

See [LICENSE](LICENSE) file.
