# VPC
variable "vpc_name" {
  description = "Name of vpc"
  type        = string
  default     = ""
}
variable "vpc_name_suffix" {
  description = "Name suffix of vpc"
  type        = string
  default     = "vpc"
}
variable "vpc_cidr" {
  description = "cidr"
  type        = string
  default     = ""
}
variable "vpc_azs" {
  type = list(string)
}
variable "vpc_private_subnets" {
  type = list(string)
}
variable "vpc_public_subnets" {
  type = list(string)
}
variable "vpc_database_subnets" {
  type = list(string)
}



variable "security_group_ids" {
  type = list(string)
}
# security group rules ingress
variable "security_group_rule_type" {
  description = "Type of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_description" {
  description = "Description of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_form_port" {
  description = "Access from port of security group rule"
  type        = number
  default     = 0
}
variable "security_group_rule_to_port" {
  description = "Access to port of security group rule"
  type        = number
  default     = 0
}
variable "security_group_rule_protocol" {
  description = "Protocol of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_cidr_blocks" {
  description = "cidr blocks of security group rule"
  type        = list(string)
  default     = []
}

# security group rules egress
variable "security_group_rule_type2" {
  description = "Type of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_description2" {
  description = "Description of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_form_port2" {
  description = "Access from port of security group rule"
  type        = number
  default     = 0
}
variable "security_group_rule_to_port2" {
  description = "Access to port of security group rule"
  type        = number
  default     = 0
}
variable "security_group_rule_protocol2" {
  description = "Protocol of security group rule"
  type        = string
  default     = ""
}
variable "security_group_rule_cidr_blocks2" {
  description = "cidr blocks of security group rule"
  type        = list(string)
  default     = []
}
