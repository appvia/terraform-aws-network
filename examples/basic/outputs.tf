
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
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
  value       = module.vpc.private_subnet_cidrs
}

output "public_subnet_cidrs" {
  description = "A list of the CIDRs for the public subnets i.e. [subnet_cidr, subnet_cidr]"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidr_by_id" {
  description = "A map of the private subnet ID to CIDR block i.e. us-west-2a => subnet_cidr"
  value       = module.vpc.private_subnet_cidr_by_id
}

output "public_subnet_cidr_by_id" {
  description = "A map of the public subnet ID to CIDR block i.e. us-west-2a => subnet_cidr"
  value       = module.vpc.public_subnet_cidr_by_id
}

output "private_subnet_id_by_az" {
  description = "A map of availability zone to subnet id of the private subnets i.e. eu-west-2a => subnet_id"
  value       = module.vpc.private_subnet_id_by_az
}

output "public_subnet_id_by_az" {
  description = "A map of availability zone to subnet id of the public subnets i.e. eu-west-2a => subnet_id"
  value       = module.vpc.public_subnet_id_by_az
}

output "private_subnet_attributes_by_az" {
  description = "The attributes of the private subnets (see aws-ia/vpc/aws for details)"
  value       = module.vpc.private_subnet_attributes_by_az
}

output "public_subnet_attributes_by_az" {
  description = "The attributes of the public subnets (see aws-ia/vpc/aws for details)"
  value       = module.vpc.public_subnet_attributes_by_az
}

output "transit_subnet_attributes_by_az" {
  description = "The attributes of the transit gateway subnets (see aws-ia/vpc/aws for details)"
  value       = module.vpc.transit_subnet_attributes_by_az
}

output "natgw_id_per_az" {
  description = "The IDs of the NAT Gateways (see aws-ia/vpc/aws for details)"
  value       = module.vpc.natgw_id_per_az
}

output "rt_attributes_by_type_by_az" {
  description = "The attributes of the route tables (see aws-ia/vpc/aws for details)"
  value       = module.vpc.rt_attributes_by_type_by_az
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets i.e. [subnet_id, subnet_id]"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets i.e. [subnet_id, subnet_id]"
  value       = module.vpc.public_subnet_ids
}

output "transit_subnet_ids" {
  description = "The IDs of the transit gateway subnets ie. [subnet_id, subnet_id]"
  value       = module.vpc.transit_subnet_ids
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables ie. [route_table_id, route_table_id]"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "The IDs of the public route tables ie. [route_table_id, route_table_id]"
  value       = module.vpc.public_route_table_ids
}

output "transit_route_table_ids" {
  description = "The IDs of the transit gateway route tables ie. [route_table_id, route_table_id]"
  value       = module.vpc.transit_route_table_ids
}

output "transit_route_table_by_az" {
  description = "A map of availability zone to transit gateway route table ID i.e eu-west-2a => route_table_id"
  value       = module.vpc.transit_route_table_by_az
}

output "transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment if enabled"
  value       = module.vpc.transit_gateway_attachment_id
}

output "nat_public_ips" {
  description = "The public IPs of the NAT Gateways i.e [public_ip, public_ip]"
  value       = module.vpc.nat_public_ips
}
