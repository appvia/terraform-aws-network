#
## Related to the outputs of the module 
#

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_attributes.id
}

output "private_subnet_netmask" {
  description = "The netmask for the private subnets"
  value       = var.private_subnet_netmask
}

output "public_subnet_netmask" {
  description = "The netmask for the public subnets"
  value       = var.public_subnet_netmask
}

output "private_subnet_list" {
  description = "A list of the CIDRs for the private subnets"
  value       = local.private_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "A map of the CIDRs for the private subnets"
  value       = local.private_subnet_cidr_map
}

output "public_subnet_list" {
  description = "A list of the CIDRs for the public subnets"
  value       = local.public_subnet_cidrs
}

output "private_subnet_attributes_by_az" {
  description = "The attributes of the private subnets"
  value       = module.vpc.private_subnet_attributes_by_az
}

output "public_subnet_attributes_by_az" {
  description = "The attributes of the public subnets"
  value       = var.public_subnet_netmask > 0 ? module.vpc.public_subnet_attributes_by_az : null
}

output "transit_subnet_attributes_by_az" {
  description = "The attributes of the transit gateway subnets"
  value       = var.enable_transit_gateway ? module.vpc.tgw_subnet_attributes_by_az : null
}

output "natgw_id_per_az" {
  description = "The IDs of the NAT Gateways"
  value       = var.enable_nat_gateway ? module.vpc.natgw_id_per_az : null
}

output "rt_attributes_by_type_by_az" {
  description = "The attributes of the route tables"
  value       = module.vpc.rt_attributes_by_type_by_az
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = local.private_subnet_ids
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = local.public_subnet_ids
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = local.private_route_table_ids
}

output "transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment"
  value       = var.enable_transit_gateway ? module.vpc.transit_gateway_attachment_id : null
}

output "transit_subnet_ids" {
  description = "The IDs of the transit gateway subnets"
  value       = var.enable_transit_gateway ? local.transit_subnet_ids : null
}

output "nat_public_ips" {
  description = "The public IPs of the NAT Gateways"
  value       = var.enable_nat_gateway ? [] : [for x in module.vpc.nat_gateway_attributes_by_az : x.public_ip]
}

