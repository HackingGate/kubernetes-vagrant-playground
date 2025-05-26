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
  default = "k8s"
}

variable "version" {
  type    = string
  default = "v1.33"
}

source "vagrant" "k8s-base" {
  provider     = "libvirt"
  communicator = "ssh"
  source_path  = "common-base"  # Use common-base box instead of generic/debian12
  add_force    = true
  box_name     = "k8s-base"
}

build {
  sources = ["source.vagrant.k8s-base"]

  provisioner "ansible" {
    playbook_file = "./k8s/base-playbook.yml"
    user          = "vagrant"
    use_proxy     = false

    extra_arguments = [
      "--extra-vars", "k8s_version=${var.version}"
    ]
  }
}
