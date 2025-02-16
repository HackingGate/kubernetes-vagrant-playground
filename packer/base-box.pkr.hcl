packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "k8s_version" {
  type    = string
  default = "v1.32"
}

variable "pod_network_cidr" {
  type    = string
  default = "10.244.0.0/16"
}

source "vagrant" "k8s-base" {
  provider          = "libvirt"
  communicator      = "ssh"
  insert_key        = true
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"
  ssh_port          = 22
  ssh_wait_timeout  = "60s"
  source_path       = "generic/debian12"
  add_force         = true
  box_name          = "k8s-base"
}

build {
  sources = ["source.vagrant.k8s-base"]

  provisioner "shell-local" {
    inline = ["echo foo"]
  }

  provisioner "ansible" {
    playbook_file     = "./base-playbook.yml"
    user              = "vagrant"
    use_proxy         = false
    extra_arguments = [
      "--private-key", "./output-k8s-base/.vagrant/machines/source/libvirt/private_key",
      "--extra-vars", "ansible_password=vagrant",
      "--extra-vars", "k8s_version=${var.k8s_version}",
      "--extra-vars", "pod_network_cidr=${var.pod_network_cidr}",
      "-vvvv"
    ]
  }
}
