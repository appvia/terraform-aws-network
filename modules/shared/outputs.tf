
output "inbound_network_acls" {
  description = "The inbound network ACLs provisioned"
  value       = local.network_inbound_acls
}

output "outbound_network_acls" {
  description = "The outbound network ACLs provisioned"
  value       = local.network_outbound_acls
}

output "subnets_map" {
  description = "A map of the subnets"
  value       = local.subnets
}

output "subnet_ids_by_name" {
  description = "A map of the subnets ids by the name"
  value       = local.subnets_ids_by_name
}

output "subnet_ids" {
  description = "A list of all the subnet ids"
  value       = local.subnets_ids
}

output "route_table" {
  description = "The route table provisioned"
  value       = aws_route_table.current.id
}

output "route_table_arn" {
  description = "The route table arn"
  value       = aws_route_table.current.arn
}
