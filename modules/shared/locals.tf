locals {
  ## The name of the RAM share
  ram_share_name = format("%s%s", var.ram_share_prefix, lower(var.name))

  ## A map from the var.subnets, which is the KEY-CIDR block
  subnets = merge([
    for k, v in var.subnets : {
      for i, cidr in v.cidrs : format("%s-%s", k, cidr) => {
        availability_zone = data.aws_availability_zones.current.names[i]
        cidr_block        = cidr
        name              = format("%s-%s-%s", var.name, k, data.aws_availability_zones.current.names[i])
        subnet_prefix     = format("%s-%s-", var.name, k)
        subnet_name       = k
      }
    }
  ]...)

  ## A map of all the network acls that need to be created
  network_inbound_acls = merge([
    for index, v in keys(local.subnets) : {
      (v) = {
        cidr_block  = local.subnets[v].cidr_block
        rule_number = 100 + index
      }
    }
  ]...)

  ## A map of all the network acls that need to be created
  network_outbound_acls = merge([
    for index, v in keys(local.subnets) : {
      (v) = {
        cidr_block  = local.subnets[v].cidr_block
        rule_number = 200 + index
      }
    }
  ]...)

  ## A collection of tags to apply to the subnets
  tags = merge(var.tags, {})

  ## A collection of subnets ids by the name
  subnets_ids_by_name = {
    for k, v in var.subnets : k => [for s in aws_subnet.subnets : s.id if startswith(s.tags["Name"], format("%s-%s-", var.name, k))]
  }

  ## A list of all the subnet ids 
  subnets_ids = flatten([for k, v in local.subnets_ids_by_name : local.subnets_ids_by_name[k]])
}
