
locals {
  # The id for the transit_gateway_id passed into the module
  transit_gateway_id = var.enable_transit_gateway ? var.transit_gateway_id : null

  # Is the routes to propagate down the transit gateway 
  transit_routes = var.enable_transit_gateway && length(var.transit_gateway_routes) > 0 ? var.transit_gateway_routes : null

  # The configuration for the private subnets
  private_subnet = {
    private = {
      connect_to_public_natgw = var.enable_nat_gateway ? true : null
      netmask                 = var.private_subnet_netmask
      tags                    = var.tags
    }
  }

  # Public subnets are optional
  public_subnet = var.public_subnet_netmask > 0 ? {
    public = {
      connect_to_public_natgw   = var.enable_nat_gateway ? true : null
      nat_gateway_configuration = var.nat_gateway_mode
      netmask                   = var.public_subnet_netmask
      tags                      = var.tags
    }
  } : null

  # We use the discovered IPAM pool id if the user has not provided one
  ipam_pool_id = var.enable_ipam ? data.aws_vpc_ipam_pool.current[0].id : null

  # Configuration for the transit subnets 
  transit_subnet = var.enable_transit_gateway ? {
    transit_gateway = {
      connect_to_public_natgw                         = var.enable_transit_gateway_subnet_natgw
      netmask                                         = 28
      tags                                            = var.tags
      transit_gateway_appliance_mode_support          = var.enable_transit_gateway_appliance_mode ? "enable" : "disable"
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      transit_gateway_dns_support                     = "enable"
    }
  } : null

  # private subnet ranges 
  private_subnet_cidrs = [for k, x in module.vpc.private_subnet_attributes_by_az : x.cidr_block if startswith(k, "private/")]
  # private subnet range map 
  private_subnet_cidr_map = { for k, x in module.vpc.private_subnet_attributes_by_az : x.id => x.cidr_block if startswith(k, "private/") }
  #

  # public_subnet ranges 
  public_subnet_cidrs = [for k, x in module.vpc.public_subnet_attributes_by_az : x.cidr_block]

  # The subnet id for the private subnets
  private_subnet_ids = [for k, x in module.vpc.private_subnet_attributes_by_az : x.id if startswith(k, "private/")]
  # The subnet id for the public subnets
  public_subnet_ids = [for k, x in module.vpc.public_subnet_attributes_by_az : x.id]
  # The subnet id for the transit subnets
  transit_subnet_ids = [for k, x in module.vpc.tgw_subnet_attributes_by_az : x.id]
  # The routing tables for the private subnets
  private_route_table_ids = [for k, x in module.vpc.rt_attributes_by_type_by_az.private : x.id]
  # The transgit gateway route table ids 

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
}

