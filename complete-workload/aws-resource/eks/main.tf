module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "${var.cluster_name}-${var.cluster_name_suffix}"
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    disk_size      = var.disk_size
    instance_types = var.default_instance_types
  }

  eks_managed_node_groups = zipmap(
    [for name, node_group in var.manage_node_groups : "${var.cluster_name}-${node_group.node_name}-${var.node_name_suffix}"],
    [for name, node_group in var.manage_node_groups : {
      create_iam_role          = node_group.create_iam_role
      iam_role_name            = node_group.iam_role_name
      iam_role_arn             = node_group.iam_role_arn
      iam_role_use_name_prefix = false
      min_size                 = 0
      max_size                 = 5
      capacity_type            = "ON_DEMAND"
      desired_size             = node_group.desired_size
      instance_types           = [node_group.instance_types]
      labels = {
        IngressLabel = node_group.node_name
      }
    }]
  )
}

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  vpc_id             = var.lb_vpc_id
  subnets            = var.lb_subnets
  name               = "${var.lb_name_prefix}-${var.lb_name}"
  load_balancer_type = var.lb_type

  #   https_listeners = [
  #     {
  #       port               = 443
  #       protocol           = "TLS"
  #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #       target_group_index = 0
  #     }
  #   ]

  http_tcp_listeners = [for group, tcp_listeners in var.lb_http_tcp_listeners : {
    port               = tcp_listeners.port
    protocol           = var.http_listeners_protocol
    target_group_index = index([for group, tcp_listeners in var.lb_http_tcp_listeners : group], group)
    }
  ]

  target_groups = [for group, target_group in var.target_groups : {
    name             = "${var.target_groups_name_prefix}-${var.lb_name}-${target_group.name}"
    backend_protocol = var.target_groups_backend_protocol
    backend_port     = target_group.backend_port
    target_type      = var.target_type
    }
  ]


  # access_logs = {
  #   bucket  = var.access_logs_bucket_name
  #   prefix  = var.access_logs_prefix
  #   enabled = var.access_logs_enabled
  # }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  for_each = zipmap(
    [for name, node_group in module.eks.eks_managed_node_groups : name],
    [for name, node_group in module.eks.eks_managed_node_groups : node_group]
  )

  autoscaling_group_name = each.value.node_group_resources[0].autoscaling_groups[0].name
  alb_target_group_arn   = var.alb_target_group_arn["${index([for name, node_group in module.eks.eks_managed_node_groups : name], each.key)}"]
}
