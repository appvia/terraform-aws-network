
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_attributes.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_attributes.cidr_block
}

output "vpc_attributes" {
  description = "The attributes of the VPC (see aws-ia/vpc/aws for details)"
  value       = module.vpc.vpc_attributes
}

output "private_subnet_cidrs" {
  description = "A list of the CIDRs for the private subnets"
  value       = local.private_subnet_cidrs
}

output "private_subnet_id_by_az" {
  description = "A map of availability zone to subnet id of the private subnets i.e. eu-west-2a => subnet_id"
  value       = local.private_subnet_id_by_az
}

output "private_subnet_attributes_by_az" {
  description = "The attributes of the private subnets (see aws-ia/vpc/aws for details)"
  value       = module.vpc.private_subnet_attributes_by_az
}

output "private_subnet_cidr_by_id" {
  description = "A map of subnet id to CIDR block of the private subnets i.e. subnet_id => cidr_block"
  value       = local.private_subnet_cidr_by_id
}

output "transit_subnet_attributes_by_az" {
  description = "The attributes of the transit gateway subnets (see aws-ia/vpc/aws for details)"
  value       = var.enable_transit_gateway ? module.vpc.tgw_subnet_attributes_by_az : null
}

output "natgw_id_per_az" {
  description = "The IDs of the NAT Gateways (see aws-ia/vpc/aws for details)"
  value       = var.enable_nat_gateway ? module.vpc.natgw_id_per_az : null
}

output "rt_attributes_by_type_by_az" {
  description = "The attributes of the route tables (see aws-ia/vpc/aws for details)"
  value       = module.vpc.rt_attributes_by_type_by_az
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets i.e. [subnet_id, subnet_id]"
  value       = local.private_subnet_ids
}

output "transit_subnet_ids" {
  description = "The IDs of the transit gateway subnets ie. [subnet_id, subnet_id]"
  value       = var.enable_transit_gateway ? local.transit_subnet_ids : null
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables ie. [route_table_id, route_table_id]"
  value       = local.private_route_table_ids
}

output "transit_route_table_ids" {
  description = "The IDs of the transit gateway route tables ie. [route_table_id, route_table_id]"
  value       = var.enable_transit_gateway ? local.transit_route_table_ids : null
}

output "transit_route_table_by_az" {
  description = "A map of availability zone to transit gateway route table ID i.e eu-west-2a => route_table_id"
  value       = var.enable_transit_gateway ? local.transit_route_table_by_az : null
}

output "transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment if enabled"
  value       = var.enable_transit_gateway ? module.vpc.transit_gateway_attachment_id : null
}

output "nat_public_ips" {
  description = "The public IPs of the NAT Gateways i.e [public_ip, public_ip]"
  value       = var.enable_nat_gateway ? [] : [for x in module.vpc.nat_gateway_attributes_by_az : x.public_ip]
}
