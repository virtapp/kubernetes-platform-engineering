
###---Application
resource "kubernetes_manifest" "apache" {
  manifest = yamldecode(<<-EOF
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: apache
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: https://charts.bitnami.com/bitnami
        chart: apache
        targetRevision: 10.1.1
        helm:
          values: |
            service:
              type: ClusterIP
            replicaCount: 2
      destination:
        server: https://kubernetes.default.svc
        namespace: default
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
  EOF
  )
}
