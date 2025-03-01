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
  default = "{{ distribution }}"
}

variable "version" {
  type    = string
  default = "{{ version }}"
}

source "vagrant" "{{ distribution }}-base" {
  provider     = "libvirt"
  communicator = "ssh"
  source_path  = "generic/debian12"
  add_force    = true
  box_name     = "{{ distribution }}-base"
}

build {
  sources = ["source.vagrant.{{ distribution }}-base"]

  provisioner "ansible" {
    playbook_file = "./{{ distribution }}/base-playbook.yml"
    user          = "vagrant"
    use_proxy     = false

    extra_arguments = [
      "--extra-vars", "{{ distribution }}_version=${var.version}"
    ]
  }
}
