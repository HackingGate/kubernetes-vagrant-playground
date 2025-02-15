# -*- mode: ruby -*-
# vi: set ft=ruby :

K8S_VERSION = "v1.32"
POD_NETWORK_CIDR = "10.244.0.0/16"
CONTROL_IP = "192.168.121.10"
WORKER_IPS = ["192.168.121.11", "192.168.121.12"]

Vagrant.configure("2") do |config|
  config.vm.box = "./output-k8s-base/package.box"
  config.vm.box_check_update = false
  
  # SSH key configuration for Ansible
  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  # Configure Ansible defaults
  ansible_config = proc do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.become = true
    ansible.extra_vars = {
      k8s_version: K8S_VERSION,
      pod_network_cidr: POD_NETWORK_CIDR,
      control_ip: CONTROL_IP,
    }
  end

  # Control Node
  config.vm.define "k8s-control" do |control|
    control.vm.hostname = "k8s-control"
    control.vm.network "private_network", ip: CONTROL_IP

    # Trigger to remove obsolete k8s-join.sh from the host machine
    control.trigger.before [:destroy, :halt, :provision, :reload, :resume, :suspend, :up] do |trigger|
      trigger.name = "Remove obsolete k8s-join.sh from host"
      trigger.run = { inline: "rm -f ./k8s-join.sh" }
    end

    control.vm.provider "libvirt" do |lv|
      lv.memory = 2048
      lv.cpus = 2
      lv.cpu_mode = "host-passthrough"
    end

    control.vm.provision "ansible" do |ansible|
      ansible_config.call(ansible)
      ansible.playbook = "playbook.yml"
      ansible.tags = ["control"]
    end
  end

  # Worker Nodes
  WORKER_IPS.each_with_index do |ip, i|
    config.vm.define "k8s-worker-#{i+1}", depends_on: ["k8s-control"] do |worker|
      worker.vm.hostname = "k8s-worker-#{i+1}"
      worker.vm.network "private_network", ip: ip
      
      worker.vm.provider "libvirt" do |lv|
        lv.memory = 2048
        lv.cpus = 2
        lv.cpu_mode = "host-passthrough"
      end
      
      worker.vm.provision "ansible" do |ansible|
        ansible_config.call(ansible)
        ansible.playbook = "playbook.yml"
        ansible.tags = ["worker"]
      end
    end
  end

  # Configure libvirt defaults
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.host = "localhost"
    libvirt.uri = "qemu:///system"
  end
end
