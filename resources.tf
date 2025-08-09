
# Adjust this to your kubeconfig path
provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
provider "argocd" {
  server_addr = "argocd-server.argocd.svc.cluster.local:443"
  username    = "admin"
  password    = "admin"
  insecure    = true
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




