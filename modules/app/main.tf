
# Adjust this to your kubeconfig path
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# 4️⃣ Ingress for the app
resource "kubernetes_ingress_v1" "argo-ingress" {
  #depends_on = [module.argo]
  metadata {
    name      = "ingress-route-argo"
    namespace = "argocd"
    labels = {
      name = "argocd"
    }
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      "nginx.ingress.kubernetes.io/affinity" = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name" = "route-argo"
      "nginx.ingress.kubernetes.io/session-cookie-expires" = "172800"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "172800"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "300s"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "300s"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "300s"
      "nginx.ingress.kubernetes.io/send-timeout" = "300"
      "nginx.ingress.kubernetes.io/client-body-buffer-size" = "5m"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "5m"
    }
  }

  spec {
    rule {
      host = "argo.local.com"
      http {
        path {
          backend {
            service{
              name = "argocd-server"
              port {
               number = 80
               }
          }
        }
      }
    }
  }
  tls {
      secret_name = "argo-tls"
    }
 }
}


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
