
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



