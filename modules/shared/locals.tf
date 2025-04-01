locals {
  ## The name of the RAM share
  ram_share_name = format("%s%s", var.ram_share_prefix, lower(var.name))

  ## A map from the var.subnets, which is the KEY-CIDR block
  subnets = merge([
    for k, v in var.subnets : {
      for i, cidr in v.cidrs : format("%s-%s", k, cidr) => {
        name              = format("%s-%s-%s", var.name, k, data.aws_availability_zones.current.names[i])
        availability_zone = data.aws_availability_zones.current.names[i]
        cidr_block        = cidr
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
}
