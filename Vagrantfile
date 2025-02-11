# -*- mode: ruby -*-
# vi: set ft=ruby :

MASTER_IP = "192.168.121.10"
WORKER_IPS = ["192.168.121.11", "192.168.121.12"]

Vagrant.configure("2") do |config|
  config.vm.box = "alvistack/ubuntu-24.04"
  config.vm.box_check_update = false
  
  # SSH key configuration for Ansible
  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  # Configure Ansible defaults
  ansible_config = proc do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.become = true
  end

  # Master Node
  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: MASTER_IP
    
    master.vm.provider "libvirt" do |lv|
      lv.memory = 8192
      lv.cpus = 4
      lv.cpu_mode = "host-passthrough"
    end

    master.vm.provision "ansible" do |ansible|
      ansible_config.call(ansible)
      ansible.playbook = "scripts/install-docker.yml"
    end
    master.vm.provision "ansible" do |ansible|
      ansible_config.call(ansible)
      ansible.playbook = "scripts/install-kubernetes.yml"
    end
    master.vm.provision "ansible" do |ansible|
      ansible_config.call(ansible)
      ansible.playbook = "scripts/install-helm.yml"
    end
    master.vm.provision "shell", path: "scripts/master.sh"
  end

  # Worker Nodes
  WORKER_IPS.each_with_index do |ip, i|
    config.vm.define "k8s-worker-#{i+1}" do |worker|
      worker.vm.hostname = "k8s-worker-#{i+1}"
      worker.vm.network "private_network", ip: ip
      
      worker.vm.provider "libvirt" do |lv|
        lv.memory = 12288
        lv.cpus = 6
        lv.cpu_mode = "host-passthrough"
      end
      
      worker.vm.provision "ansible" do |ansible|
        ansible_config.call(ansible)
        ansible.playbook = "scripts/install-docker.yml"
      end
      worker.vm.provision "ansible" do |ansible|
        ansible_config.call(ansible)
        ansible.playbook = "scripts/install-kubernetes.yml"
      end
      worker.vm.provision "shell", path: "scripts/worker.sh", args: [MASTER_IP]
    end
  end

  # Configure libvirt defaults
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.host = "localhost"
    libvirt.uri = "qemu:///system"
  end
end
