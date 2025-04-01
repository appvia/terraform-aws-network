
output "network_inbound_acls" {
  description = "The inbound network ACLs provisioned"
  value       = module.subnets.inbound_network_acls
}

output "network_outbound_acls" {
  description = "The outbound network ACLs provisioned"
  value       = module.subnets.outbound_network_acls
}
