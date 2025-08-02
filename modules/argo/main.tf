
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "6.7.13" # Check for latest version if needed
  create_namespace = true

  # Optional: override values
  # values = [file("argocd-values.yaml")]
}

