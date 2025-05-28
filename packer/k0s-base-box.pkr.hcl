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
  default = "k0s"
}

variable "version" {
  type    = string
  default = "v1.33.1+k0s.0"
}

source "vagrant" "k0s-base" {
  provider     = "libvirt"
  communicator = "ssh"
  source_path  = "generic/debian12"
  add_force    = true
  box_name     = "k0s-base"
}

build {
  sources = ["source.vagrant.k0s-base"]

  provisioner "ansible" {
    playbook_file = "./k0s/base-playbook.yml"
    user          = "vagrant"
    use_proxy     = false

    extra_arguments = [
      "--extra-vars", "k0s_version=${var.version}"
    ]
  }
}
