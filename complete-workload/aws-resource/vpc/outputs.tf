# VPC
output "vpc_name" {
  value = module.vpc.name
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

# subnet
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "database_subnets" {
  value = module.vpc.database_subnets
}

output "default_route_table_id" {
  value = module.vpc.default_route_table_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}
output "private_nat_gateway_route_ids" {
  value = module.vpc.private_nat_gateway_route_ids
}
output "igw_id" {
  value = module.vpc.igw_id
}