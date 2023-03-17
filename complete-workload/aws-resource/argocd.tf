################################################################################
# ArgoCD Engine
################################################################################
resource "helm_release" "argocd-helm" {
  depends_on = [null_resource.kubeconfig]
  name = "argocd-helm"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
}
