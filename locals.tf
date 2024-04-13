
locals {
  # Th current region
  region = data.aws_region.current.name
  # The id for the transit_gateway_id passed into the module
  transit_gateway_id = var.enable_transit_gateway ? var.transit_gateway_id : null
  # Is the routes to propagate down the transit gateway 
  transit_routes = var.enable_transit_gateway && length(var.transit_gateway_routes) > 0 ? var.transit_gateway_routes : null
  # The configuration for the private subnets
  private_subnet = var.private_subnet_netmask > 0 ? {
    private = {
      connect_to_public_natgw = var.enable_nat_gateway ? true : false
      netmask                 = var.private_subnet_netmask
      tags                    = var.tags
    }
  } : null
  # Public subnets are optional
  public_subnet = var.public_subnet_netmask > 0 ? {
    public = {
      nat_gateway_configuration = var.nat_gateway_mode
      netmask                   = var.public_subnet_netmask
      tags                      = var.tags
    }
  } : null
  # Configuration for the transit subnets 
  transit_subnet = var.enable_transit_gateway ? {
    transit_gateway = {
      connect_to_public_natgw                         = var.enable_transit_gateway_subnet_natgw
      netmask                                         = 28
      tags                                            = var.tags
      transit_gateway_appliance_mode_support          = var.enable_transit_gateway_appliance_mode ? "enable" : "disable"
      transit_gateway_default_route_table_association = var.enable_default_route_table_association
      transit_gateway_default_route_table_propagation = var.enable_default_route_table_propagation
      transit_gateway_dns_support                     = "enable"
    }
  } : null

  # A list of all the private subnets cidr blocks
  private_subnet_cidrs = [for k, x in module.vpc.private_subnet_attributes_by_az : x.cidr_block if startswith(k, "private/")]
  # A map of private subnet id to cidr block
  private_subnet_cidr_by_id = { for k, x in module.vpc.private_subnet_attributes_by_az : x.id => x.cidr_block if startswith(k, "private/") }
  # A map of az to private subnet id 
  private_subnet_id_by_az = { for k, x in module.vpc.private_subnet_attributes_by_az : trimprefix(k, "private/") => x.id if startswith(k, "private/") }
  # A map of az to public subnet id 
  public_subnet_id_by_az = var.public_subnet_netmask > 0 ? { for k, x in module.vpc.public_subnet_attributes_by_az : k => x.id } : {}
  # A map of public subnet id to cidr block 
  public_subnet_cidr_by_id = var.public_subnet_netmask > 0 ? { for k, x in module.vpc.public_subnet_attributes_by_az : x.id => x.cidr_block } : {}
  # public_subnet ranges 
  public_subnet_cidrs = var.public_subnet_netmask > 0 ? [for k, x in module.vpc.public_subnet_attributes_by_az : x.cidr_block] : []
  # The subnet id for the private subnets
  private_subnet_ids = [for k, x in module.vpc.private_subnet_attributes_by_az : x.id if startswith(k, "private/")]
  # The subnet id for the public subnets
  public_subnet_ids = var.public_subnet_netmask > 0 ? [for k, x in module.vpc.public_subnet_attributes_by_az : x.id] : []
  # The subnet id for the transit subnets
  transit_subnet_ids = var.enable_transit_gateway ? [for k, x in module.vpc.tgw_subnet_attributes_by_az : x.id] : []
  # A list of transit route table ids 
  transit_route_table_ids = var.enable_transit_gateway ? [for k, x in module.vpc.rt_attributes_by_type_by_az.transit_gateway : x.id] : []
  # The routing tables for the private subnets
  private_route_table_ids = [for k, x in module.vpc.rt_attributes_by_type_by_az.private : x.id]
  # The transgit gateway route table ids 
  public_route_table_ids = var.public_subnet_netmask > 0 ? [for k, x in module.vpc.rt_attributes_by_type_by_az.public : x.id] : []
  # A map of the route table ids for the transit gateway by az 
  transit_route_table_by_az = var.enable_transit_gateway ? { for k, v in module.vpc.rt_attributes_by_type_by_az.transit_gateway : k => v.id } : {}

  subnets = merge(
    local.private_subnet,
    local.public_subnet,
    local.transit_subnet,
    var.additional_subnets,
  )

  # A list of the private endpoints to enable ssm
  ssm_endpoints = var.enable_ssm ? ["ssmmessages", "ssm", "ec2messages"] : []
  # enabled_endpotints is a list of all the private endpoints to enable 
  enabled_endpoints = concat(var.enable_private_endpoints, local.ssm_endpoints)
  ## Build the list of resolver rules to associate with the vpc 
  resolver_rules = var.enable_route53_resolver_rules ? [for id in data.aws_route53_resolver_rules.current.resolver_rule_ids : id if !contains(var.exclude_route53_resolver_rules, id)] : []
}

