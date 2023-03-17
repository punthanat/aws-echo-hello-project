resource "kubectl_manifest" "traefik-app" {
  depends_on = [helm_release.argocd-helm]
  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.traefik.metadata_name}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "https://github.com/Devop-Intern/helm-template.git"
    path: helm/traefik
    targetRevision: HEAD
    helm:
      values: |-
        echoserver:
          name: ${var.traefik.echo.name}
          image: ealen/echo-server:latest
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.traefik.echo.path}
          pathType: Exact
        helloserver:
          name: ${var.traefik.hello.name}
          image: tutum/hello-world:latest
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.traefik.hello.path}
          pathType: Exact
        pgadmin:
          name: ${var.traefik.pgadmin.name}
          image: dpage/pgadmin4
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.traefik.pgadmin.path}
          pathType: Prefix
          email: ${var.traefik.pgadmin.email}
          password: ${var.traefik.pgadmin.password}
          scriptname: ${var.traefik.pgadmin.scriptname}
        ingress:
          name: ${var.traefik.ingress.name}
          pgadmin_name: ${var.traefik.ingress.pgadmin_name}
          host: ${module.eks.lb_dns_name}
        ingressctl:
          name: ${var.traefik.ingressctl.name}
          nodename: ${var.eks.manage_node_groups.group_2.node_name}
          namespaceapp: argocd
          namespacedest: traefik
          project: default
          chart: traefik
          repo: https://helm.traefik.io/traefik
          targetrevision: 10.15.0
          server: https://kubernetes.default.svc
        nodeport:
          name: ${var.traefik.nodeport.name}
          namespace: traefik
          type: NodePort
          porthttp: 80
          porthttps: 443
          tghttp: 8000
          tghttps: 8443
          protocal: TCP
          nodeport: ${var.nlb.target_groups.group_2.backend_port}
          http: http
          https: https
          app: traefik
  destination:
    server: "https://kubernetes.default.svc"
    namespace: traefik-workload
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML
}