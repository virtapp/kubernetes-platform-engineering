terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "null" {}

resource "null_resource" "install_k3s" {
  provisioner "local-exec" {
    command = "export K3S_EXEC_FLAGS='--disable=traefik --disable=local-storage' && bash ./modules/k3s/install_k3s.sh ${var.node_role} ${var.k3s_version}"
  }

  triggers = {
    always_run = "${timestamp()}"

  }
}

resource "null_resource" "k3s_config" {
  provisioner "local-exec" {
    command = "mkdir -p ~/.kube/ && cp -r /etc/rancher/k3s/k3s.yaml ~/.kube/config"
  }
  depends_on = [null_resource.install_k3s]
}


resource "null_resource" "k3s_status" {
  provisioner "local-exec" {
    command = "sleep 5 && systemctl status k3s | grep -v k3s 2>/dev/null"
  }
  depends_on = [null_resource.k3s_config]
}
