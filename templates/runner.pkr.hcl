packer {
  required_plugins {
    tart = {
      version = ">= 1.2.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "runner_token" {
  type = string
}

variable "runner_url" {
  type = string
}

source "tart-cli" "tart" {
  vm_base_name = "sonoma-xcode:15.2"
  vm_name      = "runner-xcode:15.2"
  cpu_count    = 4
  memory_gb    = 8
  disk_size_gb = 90
  headless     = true
  ssh_password = "admin"
  ssh_username = "admin"
  ssh_timeout  = "120s"
}

build {
  sources = ["source.tart-cli.tart"]

  // install the actions runner service
  provisioner "shell" {
    inline = [
      "brew install mint",
      "cd $HOME/actions-runner",
      "./config.sh --url ${var.runner_url} --token ${var.runner_token}",
      "echo \"/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin\" > .path",
      "./svc.sh install",
    ]
  }
}
