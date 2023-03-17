resource "kubectl_manifest" "kong-app" {
  depends_on = [helm_release.argocd-helm]
  yaml_body  = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.kong.metadata_name}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "https://github.com/Devop-Intern/helm-template.git"
    path: helm/kong
    targetRevision: HEAD
    helm:
      values: |-
        echoserver:
          name: ${var.kong.echo.name}
          image: ealen/echo-server:latest
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.kong.echo.path}
          pathType: Exact
        helloserver:
          name: ${var.kong.hello.name}
          image: tutum/hello-world:latest
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.kong.hello.path}
          pathType: Exact
        pgadmin:
          name: ${var.kong.pgadmin.name}
          image: dpage/pgadmin4
          replicas: 1
          containerPort: 80
          serviceType: ClusterIP
          servicePort: 80
          path: ${var.kong.pgadmin.path}
          pathType: Prefix
          email: ${var.kong.pgadmin.email}
          password: ${var.kong.pgadmin.password}
          scriptname: ${var.kong.pgadmin.scriptname}
        ingress:
          name: ${var.kong.ingress.name}
          pgadmin_name: ${var.kong.ingress.pgadmin_name}
          host: ${module.eks.lb_dns_name}
        ingressctl:
          name: ${var.kong.ingressctl.name}
          nodename: ${var.eks.manage_node_groups.group_1.node_name}
          namespaceapp: argocd
          namespacedest: kong
          project: default
          chart: kong
          repo: https://charts.konghq.com
          targetrevision: 2.7.0
          server: https://kubernetes.default.svc
        nodeport:
          name: ${var.kong.nodeport.name}
          namespace: kong
          type: NodePort
          porthttp: 80
          porthttps: 443
          tghttp: 8000
          tghttps: 8443
          protocal: TCP
          nodeport: ${var.nlb.target_groups.group_1.backend_port}
          http: http
          https: https
          app: kong
  destination:
    server: "https://kubernetes.default.svc"
    namespace: kong-workload
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
YAML
}
