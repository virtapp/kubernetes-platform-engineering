
resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
  # Optional: override default chart values
  values = [
    <<EOF
replicaCount: 2
service:
  type: LoadBalancer
EOF
  ]
}
