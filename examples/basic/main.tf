
## Provision a VPC with public and private subnets
module "vpc" {
  source = "../.."

  availability_zones     = var.availability_zones
  enable_ipam            = var.enable_ipam
  enable_ssm             = var.enable_ssm
  enable_transit_gateway = var.enable_transit_gateway
  name                   = var.name
  private_subnet_netmask = var.private_subnet_netmask
  public_subnet_netmask  = var.public_subnet_netmask
  tags                   = var.tags
  transit_gateway_id     = var.transit_gateway_id
  vpc_cidr               = var.vpc_cidr
}
