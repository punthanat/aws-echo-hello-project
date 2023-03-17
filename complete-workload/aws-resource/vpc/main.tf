module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}-${var.vpc_name_suffix}"
  cidr = var.vpc_cidr

  enable_dns_hostnames         = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  azs                          = var.vpc_azs
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  map_public_ip_on_launch      = false
  create_database_subnet_group = false
  database_subnets             = var.vpc_database_subnets
}

# security group rules
resource "aws_security_group_rule" "access_rule" {
  for_each = zipmap(
    [for group, security_group_ids in var.security_group_ids : group],
    [for group, security_group_ids in var.security_group_ids : security_group_ids]
  )
  type              = var.security_group_rule_type
  description       = var.security_group_rule_description
  from_port         = var.security_group_rule_form_port
  to_port           = var.security_group_rule_to_port
  protocol          = var.security_group_rule_protocol
  security_group_id = each.value
  cidr_blocks       = var.security_group_rule_cidr_blocks
}

resource "aws_security_group_rule" "access_rule2" {
  for_each = zipmap(
    [for group, security_group_ids in var.security_group_ids : group],
    [for name, security_group_ids in var.security_group_ids : security_group_ids]
  )
  type              = var.security_group_rule_type2
  description       = var.security_group_rule_description2
  from_port         = var.security_group_rule_form_port2
  to_port           = var.security_group_rule_to_port2
  protocol          = var.security_group_rule_protocol2
  security_group_id = each.value
  cidr_blocks       = var.security_group_rule_cidr_blocks2
}
