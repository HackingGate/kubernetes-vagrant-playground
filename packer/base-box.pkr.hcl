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

source "vagrant" "k8s-base" {
  provider          = "libvirt"
  communicator      = "ssh"
  source_path       = "generic/debian12"
  add_force         = true
  box_name          = "k8s-base"
}

build {
  sources = ["source.vagrant.k8s-base"]

  provisioner "ansible" {
    playbook_file     = "./base-playbook.yml"
    user              = "vagrant"
    use_proxy         = false

    extra_arguments = [
      "--extra-vars", "k8s_version=${var.k8s_version}"
    ]
  }
}
