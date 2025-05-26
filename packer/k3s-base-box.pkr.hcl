packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source  = "github.com/hashicorp/vagrant"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "distribution" {
  type    = string
  default = "k3s"
}

variable "version" {
  type    = string
  default = "1.33"
}

source "vagrant" "k3s-base" {
  provider     = "libvirt"
  communicator = "ssh"
  source_path  = "common-base"  # Use common-base box instead of generic/debian12
  add_force    = true
  box_name     = "k3s-base"
}

build {
  sources = ["source.vagrant.k3s-base"]

  provisioner "ansible" {
    playbook_file = "./k3s/base-playbook.yml"
    user          = "vagrant"
    use_proxy     = false

    extra_arguments = [
      "--extra-vars", "k3s_version=${var.version}"
    ]
  }
}
