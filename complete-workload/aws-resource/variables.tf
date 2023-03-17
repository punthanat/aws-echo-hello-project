variable "resource_name" {
  type = string
}

# EKS
variable "eks" {
  type = object({
    cluster_version = string
    manage_node_groups = map(object({
      node_name       = string
      desired_size    = number
      instance_types  = string
      create_iam_role = bool
      iam_role_name   = string
      iam_role_arn    = string
    }))
  })
}

# NLB
variable "nlb" {
  type = object({
    backend_protocol = string
    target_type      = string
    target_groups = map(object({
      name         = string
      backend_port = number
    }))
    http_tcp_listeners = map(object({
      port = number
    }))
  })
}
# access_logs    = map(string)

variable "vpc" {
  type = object({
    vpc_cidr = string
    vpc_list = map(list(string))
  })
}

# RDS
variable "rds" {
  type = map(map(string))
}

# update-kubeconfig
variable "update-kubeconfig" {
  type = string
}

# provider-aws
variable "profile" {
  type = string
}
variable "region" {
  type = string
}




# kong app
variable "kong" {
  type = object({
    metadata_name = string
    echo          = map(string)
    hello         = map(string)
    pgadmin       = map(string)
    ingress       = map(string)
    ingressctl    = map(string)
    nodeport      = map(string)
  })
}

# traefik app
variable "traefik" {
  type = object({
    metadata_name = string
    echo          = map(string)
    hello         = map(string)
    pgadmin       = map(string)
    ingress       = map(string)
    ingressctl    = map(string)
    nodeport      = map(string)
  })
}
