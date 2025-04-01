
output "inbound_network_acls" {
  description = "The inbound network ACLs provisioned"
  value       = local.network_inbound_acls
}

output "outbound_network_acls" {
  description = "The outbound network ACLs provisioned"
  value       = local.network_outbound_acls
}
