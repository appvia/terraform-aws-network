## Provision the VPC for VPN
module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = "4.4.4"

  name                     = var.name
  az_count                 = var.availability_zones
  cidr_block               = var.vpc_cidr
  subnets                  = local.subnets
  tags                     = local.tags
  transit_gateway_id       = local.transit_gateway_id
  transit_gateway_routes   = local.transit_routes
  vpc_instance_tenancy     = var.vpc_instance_tenancy
  vpc_enable_dns_hostnames = true
  vpc_enable_dns_support   = true
  vpc_ipv4_ipam_pool_id    = var.ipam_pool_id
  vpc_ipv4_netmask_length  = var.vpc_netmask
}

## Provision the NACLs for each of the subnets
module "nacls" {
  for_each = var.nacl_rules
  source   = "./modules/nacls"

  inbound_rules  = var.nacl_rules[each.key].inbound_rules
  name           = each.key
  outbound_rules = var.nacl_rules[each.key].outbound_rules
  subnet_count   = var.availability_zones
  subnet_ids     = local.all_subnets_by_name[each.key].ids
  tags           = local.tags
  vpc_id         = module.vpc.vpc_attributes.id

  depends_on = [module.vpc]
}
