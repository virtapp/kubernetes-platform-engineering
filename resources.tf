
# Adjust this to your kubeconfig path
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

module "nginx" {
  source = "./modules/nginx"
  depends_on = [null_resource.k3s_status] 
}

module "argo" {
  source = "./modules/argo"
  depends_on = [module.nginx] 
}

# 4️⃣ Ingress for the app
resource "kubernetes_ingress_v1" "argo-ingress" {
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
      secret_name = "local"
    }
 }
}



