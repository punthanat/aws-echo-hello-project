module "eks" {
  source = "./eks"

  # EKS Cluster
  cluster_name    = var.resource_name
  cluster_version = var.eks.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Manage node groups
  manage_node_groups = var.eks.manage_node_groups

  # NLB
  lb_vpc_id                      = module.vpc.vpc_id
  lb_subnets                     = module.vpc.public_subnets
  lb_name                        = var.resource_name
  target_groups_backend_protocol = var.nlb.backend_protocol
  target_type                    = var.nlb.target_type
  target_groups                  = var.nlb.target_groups
  lb_http_tcp_listeners          = var.nlb.http_tcp_listeners
  # access_logs_bucket_name           = var.nlb.access_logs.bucket_name
  # access_logs_prefix                = var.nlb.access_logs.prefix 
  # access_logs_enabled               = var.nlb.access_logs.enabled 

  # autocaling group
  alb_target_group_arn = sort(module.eks.nlb_target_group_arns)

}

module "vpc" {
  source = "./vpc"

  # VPC
  vpc_name = var.resource_name
  vpc_cidr = var.vpc.vpc_cidr

  vpc_azs              = var.vpc.vpc_list.vpc_azs
  vpc_private_subnets  = var.vpc.vpc_list.vpc_private_subnets
  vpc_public_subnets   = var.vpc.vpc_list.vpc_public_subnets
  vpc_database_subnets = var.vpc.vpc_list.vpc_database_subnets

  # security group rule ingress
  security_group_ids = [for name, node_group in module.eks.eks_managed_node_groups : node_group.security_group_id]

  security_group_rule_type        = "ingress"
  security_group_rule_description = "inbound all port"
  security_group_rule_form_port   = 0
  security_group_rule_to_port     = 65535
  security_group_rule_protocol    = "all"
  security_group_rule_cidr_blocks = ["0.0.0.0/0"]

  #security group rule egress
  security_group_rule_type2        = "egress"
  security_group_rule_description2 = "outbound all port"
  security_group_rule_form_port2   = 0
  security_group_rule_to_port2     = 65535
  security_group_rule_protocol2    = "all"
  security_group_rule_cidr_blocks2 = ["0.0.0.0/0"]
  
}

module "rds" {
  source = "./rds"

  # RDS
  resource_name               = var.resource_name
  rds_sg_vpc_id               = module.vpc.vpc_id
  rds_engine                  = var.rds.app.rds_engine
  rds_engine_version          = var.rds.app.rds_engine_version
  rds_instance_class          = var.rds.app.rds_instance_class
  rds_allocated_storage       = var.rds.app.rds_allocated_storage
  rds_max_allocated_storage   = var.rds.app.rds_max_allocated_storage
  rds_username                = var.rds.app.rds_username
  rds_password                = var.rds.app.rds_password
  rds_port                    = var.rds.app.rds_port
  rds_vpc_security_group_ids  = module.rds.security_group_id
  db_subnet_group_description = var.rds.app.db_subnet_group_description
  subnet_ids                  = module.vpc.database_subnets

  #rds security group
  security_group_description      = var.rds.rds_security_group.security_group_description
  security_group_cidr_from_port   = var.rds.rds_security_group.security_group_cidr_from_port
  security_group_cidr_to_port     = var.rds.rds_security_group.security_group_cidr_to_port
  security_group_cidr_protocol    = var.rds.rds_security_group.security_group_cidr_protocol
  security_group_cidr_description = var.rds.rds_security_group.security_group_cidr_description
  security_group_cidr_block       = var.rds.rds_security_group.security_group_cidr_block

}




# kube-config
resource "kubectl_manifest" "kube-config" {
  depends_on = [module.eks]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-proxy
  namespace: kube-system
data:
  kubeconfig: |-
    kind: Config
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: "${module.eks.cluster_certificate_authority_data}"
        server: "${module.eks.cluster_endpoint}"
      name: "${module.eks.cluster_arn}"
    contexts:
    - context:
        cluster: "${module.eks.cluster_arn}"
        user: "${module.eks.cluster_arn}"
      name: "${module.eks.cluster_arn}"
    current-context: "${module.eks.cluster_arn}"
    preferences: {}
    users:
    - name: "${module.eks.cluster_arn}"
      user:
        exec:
          apiVersion: client.authentication.k8s.io/v1alpha1
          args:
          - --region
          - "${var.region}"
          - eks
          - get-token
          - --cluster-name
          - "${module.eks.cluster_id}"
          command: aws
          env:
          - name: AWS_PROFILE
            value: "${var.profile}"
YAML
}


# configmap
resource "kubectl_manifest" "configmap" {
  depends_on = [kubectl_manifest.kube-config]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: "${module.eks.node_groups_iam_role_arn}"
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:masters
      rolearn: arn:aws:iam::115595541515:role/aws-reserved/sso.amazonaws.com/ap-southeast-1/AWSReservedSSO_AdministratorAccess_e2ade0d67d656eb8
      username: AWSReservedSSO_AdministratorAccess_e2ade0d67d656eb8
YAML
}

# update-kubeconfig 
resource "null_resource" "kubeconfig" {
  depends_on = [kubectl_manifest.configmap]
  provisioner "local-exec" {
    command = var.update-kubeconfig
  }
}

















