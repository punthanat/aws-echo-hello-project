# security group
output "security_group_id" {
  value = module.rds_security_group.security_group_id
}
output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}
