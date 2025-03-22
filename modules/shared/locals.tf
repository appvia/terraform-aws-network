
locals {
  ## Tags associated to the subnets
  tags = merge(var.tags, {})
  ## The principals to share the subnets with
  principals = concat(var.share.accounts, var.share.organizational_units)
  ## The name of the RAM share
  ram_share_name = format("%s%s", var.ram_share_prefix, lower(var.name))
}
