#
## Provisions a network within an account
#

locals {
  # Is the IPAM pool id
  ipam_pool_id = var.enable_ipam ? data.aws_vpc_ipam_pool.current[0].id : null

  # The id for the transit_gateway_id passed into the module
  transit_gateway_id = var.enable_transit_gateway ? var.transit_gateway_id : null

  # Is the routes to propagate down the transit gateway 
  transit_routes = var.enable_transit_gateway && length(var.transit_gateway_route) > 0 ? {
    private = var.transit_gateway_route
  } : null

  # The configuration for the private subnets
  private_subnet = {
    private = {
      connect_to_public_natgw = var.enable_nat_gateway ? true : null
      netmask                 = var.private_subnet_netmask
      tags                    = var.tags
    }
  }

  # Public subnets are optional
  public_subnet = length(var.public_subnet_netmask) > 0 ? {
    public = {
      connect_to_public_natgw   = var.enable_nat_gateway ? true : null
      nat_gateway_configuration = var.nat_gateway_mode
      netmask                   = var.public_subnet_netmask
      tags                      = var.tags
    }
  } : null


  # Configuration for the transit subnets 
  transit_subnet = var.enable_transit_gateway ? {
    transit_gateway = {
      connect_to_public_natgw                         = false
      netmask                                         = 28
      tags                                            = var.tags
      transit_gateway_appliance_mode_support          = var.enable_transit_gateway_appliance_mode ? "enable" : "disable"
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      transit_gateway_dns_support                     = "enable"
    }
  } : null

  # The subnet id for the private subnets
  private_subnet_ids = [for k, x in module.vpc.private_subnet_attributes_by_az : x.id if startswith(k, "private/")]
  # The subnet id for the public subnets
  public_subnet_ids = [for k, x in module.vpc.public_subnet_attributes_by_az : x.id]
  # The subnet id for the transit subnets
  transit_subnet_ids = [for k, x in module.vpc.tgw_subnet_attributes_by_az : x.id]
  # The routing tables for the private subnets
  private_route_table_ids = [for k, x in module.vpc.rt_attributes_by_type_by_az.private : x.id]

  subnets = merge(
    local.private_subnet,
    local.public_subnet,
    local.transit_subnet,
  )
}

#
## Lookup the IPAM by protocol
#
data "aws_vpc_ipam_pool" "current" {
  count = var.enable_ipam ? 1 : 0

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}

#
## Provision the VPC for VPN
#
module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = "= 4.4.2"

  name                    = var.name
  az_count                = var.availability_zones
  tags                    = var.tags
  vpc_ipv4_ipam_pool_id   = local.ipam_pool_id
  vpc_ipv4_netmask_length = var.vpc_netmask
  transit_gateway_id      = local.transit_gateway_id
  transit_gateway_routes  = local.transit_routes
  subnets                 = local.subnets
}
