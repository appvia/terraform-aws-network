locals {
  # The account id
  account_id = data.aws_caller_identity.current.account_id
  # The current region
  region = data.aws_region.current.name
  # The id for the transit_gateway_id passed into the module
  transit_gateway_id = var.enable_transit_gateway ? var.transit_gateway_id : null
  # Is the routes to propagate down the transit gateway
  transit_routes = var.enable_transit_gateway && length(var.transit_gateway_routes) > 0 ? var.transit_gateway_routes : {}

  ## All the subnets except the private and transit gateway
  subnets = {
    for k, v in var.subnets : k => {
      availability_zones      = v.availability_zones == null ? var.availability_zones : v.availability_zones
      connect_to_public_natgw = false
      netmask                 = v.netmask
      tags                    = merge(var.tags, try(v.tags, {}))
    } if k != "transit_gateway"
  }

  # Configuration for the transit subnets
  transit_subnet = var.enable_transit_gateway ? {
    transit_gateway = {
      connect_to_public_natgw                         = var.enable_transit_gateway_subnet_natgw
      netmask                                         = 28
      tags                                            = merge(var.tags, var.transit_subnet_tags)
      transit_gateway_appliance_mode_support          = var.enable_transit_gateway_appliance_mode ? "enable" : "disable"
      transit_gateway_default_route_table_association = var.enable_default_route_table_association
      transit_gateway_default_route_table_propagation = var.enable_default_route_table_propagation
      transit_gateway_dns_support                     = "enable"
    }
  } : null

  # A map of all the subnets we are creating
  all_subnets = merge(local.subnets, local.transit_subnet)
  # A map all the subnets that need to be shared
  shared_subnets = {
    for k, v in var.subnets : k => {
      principals     = length(v.share.accounts) > 0 ? try(v.share.accounts, []) : try(v.share.organization_units, [])
      ram_share_name = format("shared-%s-%s", lower(var.name), k)
      subnet_ids = [
        for k, v in module.vpc.private_subnet_attributes_by_az : format("arn:aws:ec2:%s:%s:subnet/%s", local.region, local.account_id, v.id)
      ]
    } if length(try(v.share.accounts, [])) > 0 || length(try(v.share.organization_units, [])) > 0
  }

  # A list of all the private subnets cidr blocks
  private_subnet_cidrs = [for k, x in module.vpc.private_subnet_attributes_by_az : x.cidr_block if startswith(k, "private/")]
  # A map of private subnet id to cidr block
  private_subnet_cidr_by_id = { for k, x in module.vpc.private_subnet_attributes_by_az : x.id => x.cidr_block if startswith(k, "private/") }
  # A map of az to private subnet id
  private_subnet_id_by_az = { for k, x in module.vpc.private_subnet_attributes_by_az : trimprefix(k, "private/") => x.id if startswith(k, "private/") }
  # The subnet id for the private subnets
  private_subnet_ids = [for k, x in module.vpc.private_subnet_attributes_by_az : x.id if startswith(k, "private/")]
  # The subnet id for the transit subnets
  transit_subnet_ids = var.enable_transit_gateway ? [for k, x in module.vpc.tgw_subnet_attributes_by_az : x.id] : []
  # A list of transit route table ids
  transit_route_table_ids = var.enable_transit_gateway ? [for k, x in module.vpc.rt_attributes_by_type_by_az.transit_gateway : x.id] : []
  # The routing tables for the private subnets
  private_route_table_ids = [for k, x in module.vpc.rt_attributes_by_type_by_az.private : x.id]
  # A map of the route table ids for the transit gateway by az
  transit_route_table_by_az = var.enable_transit_gateway ? { for k, v in module.vpc.rt_attributes_by_type_by_az.transit_gateway : k => v.id } : {}
  # A list of the private endpoints to enable ssm
  ssm_endpoints = var.enable_ssm ? ["ssmmessages", "ssm", "ec2messages"] : []
  # enabled_endpotints is a list of all the private endpoints to enable
  enabled_endpoints = concat(var.enable_private_endpoints, local.ssm_endpoints)
}
