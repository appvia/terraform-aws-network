
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"

  availability_zones                    = var.availability_zones
  enable_ipam                           = var.enable_ipam
  enable_ssm                            = var.enable_ssm
  enable_transit_gateway                = var.enable_transit_gateway
  enable_transit_gateway_appliance_mode = true
  ipam_pool_id                          = data.aws_vpc_ipam_pool.current.id
  name                                  = var.name
  private_subnet_netmask                = var.private_subnet_netmask
  pulic_subnet_netmask                  = var.public_subnet_netmask
  tags                                  = var.tags
  transit_gateway_id                    = data.aws_ec2_transit_gateway.this.id
  vpc_cidr                              = var.vpc_cidr

  transit_gateway_rotues = {
    private = aws_ec2_managed_prefix_list.internal.id
  }
}
