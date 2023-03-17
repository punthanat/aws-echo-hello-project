variable "resource_name" {
  type    = string
  default = ""
}
# RDS
variable "rds_engine" {
  description = "engine of rds"
  type        = string
  default     = ""
}
variable "rds_engine_version" {
  description = "engine version of rds"
  type        = string
  default     = ""
}

# RDS Instance
variable "rds_instance_class" {
  description = "instace class of rds"
  type        = string
  default     = ""
}
variable "rds_allocated_storage" {
  description = "number of storage"
  type        = number
  default     = 0
}
variable "rds_max_allocated_storage" {
  description = "maximum number of storage"
  type        = number
  default     = 0
}
variable "rds_name_suffix" {
  description = "name suffix of database"
  type        = string
  default     = "rds"
}
variable "rds_username" {
  description = "username of database"
  type        = string
  default     = ""
}
variable "rds_password" {
  description = "password of database"
  type        = string
  default     = ""
}
variable "rds_port" {
  description = "port of database server"
  type        = string
  default     = ""
}

variable "rds_vpc_security_group_ids" {
  description = "rds vpc security group ids"
  type        = string
  default     = ""
}
variable "db_subnet_group_name_suffix" {
  description = "subnet group name suffix"
  type        = string
  default     = "rds-subnet-group"
}
variable "db_subnet_group_description" {
  description = "subnet group description"
  type        = string
  default     = ""
}
variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}


# RDS Security group
variable "security_group_name_suffix" {
  description = "security group name suffix"
  type        = string
  default     = "rds-sg"
}
variable "security_group_use_name_prefix" {
  description = "security group use name prefix"
  type        = bool
  default     = false
}
variable "security_group_description" {
  description = "security group description"
  type        = string
  default     = ""
}

variable "security_group_cidr_from_port" {
  description = "security group ingress cidr from port"
  type        = number
  default     = 0
}
variable "security_group_cidr_to_port" {
  description = "security group ingress cidr to port"
  type        = number
  default     = 0
}
variable "security_group_cidr_protocol" {
  description = "security group ingress cidr protocol"
  type        = string
  default     = ""
}
variable "security_group_cidr_description" {
  description = "security group ingress cidr description"
  type        = string
  default     = ""
}
variable "security_group_cidr_block" {
  description = "security group ingress cidr block"
  type        = string
  default     = ""
}
variable "rds_sg_vpc_id" {
  description = "rds sg vpc id"
  type        = string
  default     = ""
}