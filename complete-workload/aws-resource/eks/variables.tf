# EKS
variable "cluster_name" {
  description = "Name of Cluster"
  type        = string
  default     = ""
}
variable "cluster_name_suffix" {
  type    = string
  default = "cluster"
}
variable "cluster_version" {
  description = "Version of cluster"
  type        = string
  default     = ""
}
variable "cluster_endpoint_private_access" {
  description = "Endpoint private access to cluster"
  type        = bool
  default     = true
}
variable "cluster_endpoint_public_access" {
  description = "Endpoint public access to cluster"
  type        = bool
  default     = true
}
variable "vpc_id" {
  description = "ID of vpc"
  type        = string
  default     = ""
}
variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

# default managed node
variable "ami_type" {
  description = "Ami type of manage node group"
  type        = string
  default     = "AL2_x86_64"
}
variable "disk_size" {
  description = "Size of manage node disk"
  type        = number
  default     = 50
}
variable "default_instance_types" {
  description = "A List of default instance type "
  type        = list(string)
  default     = ["t3.medium"]
}

# managed node groups
variable "manage_node_groups" {
  type = map(object({
    node_name       = string
    desired_size    = number
    instance_types  = string
    create_iam_role = bool
    iam_role_name   = string
    iam_role_arn    = string
    })
  )
  default = {
    "key" = {
      create_iam_role = true
      desired_size    = 1
      iam_role_arn    = ""
      iam_role_name   = ""
      instance_types  = ""
      node_name       = ""
    }
  }
}

variable "node_name_suffix" {
  description = "Name suffix of manage node group"
  type        = string
  default     = "node-group"
}
variable "desired_size" {
  description = "desired number of manage node "
  type        = number
  default     = 0
}
variable "instance_types" {
  description = "A List of instance type "
  type        = list(string)
  default     = []
}


# NLB
variable "lb_vpc_id" {
  description = "ID of vpc"
  type        = string
  default     = ""
}
variable "lb_subnets" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}
variable "lb_name" {
  description = "Name of load balancer"
  type        = string
  default     = ""
}
variable "lb_name_prefix" {
  type    = string
  default = "nlb"
}
variable "lb_type" {
  description = "Type of load balancer"
  type        = string
  default     = "network"
}

variable "target_groups" {
  type = map(object({
    name         = string
    backend_port = number
  }))
  default = {
    "key" = {
      name         = ""
      backend_port = 0
    }
  }
}


variable "lb_http_tcp_listeners" {
  type = map(object({
    port = number
  }))
  default = {
    "key" = {
      port = 0
    }
  }
}

variable "http_listeners_protocol" {
  description = "http listener protocol for load balancer"
  type        = string
  default     = "TCP"
}

#nlb_target_group
variable "target_groups_name_prefix" {
  description = "Name prefix of target groups"
  type        = string
  default     = "tg"
}
variable "target_groups_backend_protocol" {
  description = "backend protocol of target groups"
  type        = string
  default     = ""
}
variable "target_type" {
  description = "target type"
  type        = string
  default     = ""
}

# access logs
variable "access_logs_bucket_name" {
  description = "Name of bucket"
  type        = string
  default     = ""
}
variable "access_logs_prefix" {
  description = "prefix of access logs"
  type        = string
  default     = ""
}
variable "access_logs_enabled" {
  description = "prefix of access logs"
  type        = bool
  default     = true
}


# autoscaling attachment
variable "autoscaling_group_name" {
  description = "Name of autoscaling group"
  type        = string
  default     = ""
}


variable "alb_target_group_arn" {
  description = "alb target group arn"
  type        = list(string)
  default     = []
}

