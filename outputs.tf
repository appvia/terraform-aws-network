
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_attributes.id
}

output "private_subnet_cidrs" {
  description = "A list of the CIDRs for the private subnets"
  value       = local.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  description = "A list of the CIDRs for the public subnets i.e. [subnet_cidr, subnet_cidr]"
  value       = local.public_subnet_cidrs
}

output "private_subnet_cidr_by_id" {
  description = "A map of the private subnet ID to CIDR block i.e. us-west-2a => subnet_cidr"
  value       = local.private_subnet_cidr_by_id
}

output "public_subnet_cidr_by_id" {
  description = "A map of the public subnet ID to CIDR block i.e. us-west-2a => subnet_cidr"
  value       = local.public_subnet_cidr_by_id
}

output "private_subnet_id_by_az" {
  description = "A map of availability zone to subnet id of the private subnets i.e. eu-west-2a => subnet_id"
  value       = local.private_subnet_id_by_az
}

output "public_subnet_id_by_az" {
  description = "A map of availability zone to subnet id of the public subnets i.e. eu-west-2a => subnet_id"
  value       = local.public_subnet_id_by_az
}

output "private_subnet_attributes_by_az" {
  description = "The attributes of the private subnets (see aws-ia/vpc/aws for details)"
  value       = module.vpc.private_subnet_attributes_by_az
}

output "public_subnet_attributes_by_az" {
  description = "The attributes of the public subnets (see aws-ia/vpc/aws for details)"
  value       = var.public_subnet_netmask > 0 ? module.vpc.public_subnet_attributes_by_az : null
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

output "public_subnet_ids" {
  description = "The IDs of the public subnets i.e. [subnet_id, subnet_id]"
  value       = local.public_subnet_ids
}

output "transit_subnet_ids" {
  description = "The IDs of the transit gateway subnets ie. [subnet_id, subnet_id]"
  value       = var.enable_transit_gateway ? local.transit_subnet_ids : null
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables ie. [route_table_id, route_table_id]"
  value       = local.private_route_table_ids
}

output "public_route_table_ids" {
  description = "The IDs of the public route tables ie. [route_table_id, route_table_id]"
  value       = local.public_route_table_ids
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
