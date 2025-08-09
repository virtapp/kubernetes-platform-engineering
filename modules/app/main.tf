
terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">= 7.0.0"
    }
  }
}

provider "argocd" {
  server_addr = "argo.local.com"
  username    = "admin"
  password    = "admin"
  insecure    = true
}

###---Application
resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/bitnami/charts.git"
      target_revision = "HEAD"
      path            = "grafana"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    sync_policy {
      automated {
        prune = true
        self_heal = true
      }
    }
  }
}
