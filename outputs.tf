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

