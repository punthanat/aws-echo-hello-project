module "db" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "~> 3.5.0"
  identifier            = "${var.resource_name}-${var.rds_name_suffix}"
  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
  name                  = var.resource_name
  username              = var.rds_username
  password              = var.rds_password
  port                  = var.rds_port

  storage_encrypted       = true
  family                  = "postgres14"
  backup_retention_period = 7
  create_monitoring_role  = true
  monitoring_interval     = "60"
  monitoring_role_name    = "${var.resource_name}RDSMonitoringRole"
  # DB snapshot is created before the DB instance is deleted, If true is specified, no DBSnapshot is created
  skip_final_snapshot = true

  vpc_security_group_ids = [var.rds_vpc_security_group_ids]

  # DB subnet group from resource "aws_subnet"
  create_db_subnet_group          = true
  db_subnet_group_use_name_prefix = false
  db_subnet_group_name            = "${var.resource_name}-${var.db_subnet_group_name_suffix}"
  db_subnet_group_description     = var.db_subnet_group_description
  subnet_ids                      = var.subnet_ids
}

module "rds_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name            = "${var.resource_name}-${var.security_group_name_suffix}"
  use_name_prefix = var.security_group_use_name_prefix
  description     = var.security_group_description
  vpc_id          = var.rds_sg_vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = var.security_group_cidr_from_port
      to_port     = var.security_group_cidr_to_port
      protocol    = var.security_group_cidr_protocol
      description = var.security_group_cidr_description
      cidr_blocks = var.security_group_cidr_block
    }
  ]
}
