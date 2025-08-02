
###---Application
provider "kubernetes" {
  config_context_cluster = "default"
  config_path = "/etc/rancher/k3s/k3s.yaml"
}

resource "kubernetes_manifest" "jupyterhub" {
  manifest = yamldecode(<<-EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: jupyterhub
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://jupyterhub.github.io/helm-chart/
    chart: jupyterhub
    targetRevision: 3.3.6   # use `helm search repo jupyterhub` to get the latest
    helm:
      parameters:
        - name: hub.admin.users[0]
          value: admin
        - name: hub.config.JupyterHub.authenticator_class
          value: dummy
        - name: proxy.service.type
          value: ClusterIP
  destination:
    server: https://kubernetes.default.svc
    namespace: jupyterhub
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
 )
}
