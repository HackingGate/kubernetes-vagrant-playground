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

source "vagrant" "common-base" {
  provider     = "libvirt"
  communicator = "ssh"
  source_path  = "generic/debian12"
  add_force    = true
  box_name     = "common-base"
}

build {
  sources = ["source.vagrant.common-base"]

  provisioner "ansible" {
    playbook_file = "./common/common-base-playbook.yml"
    user          = "vagrant"
    use_proxy     = false
  }
}
