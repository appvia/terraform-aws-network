
## Provision a VPC with public and private subnets
module "vpc" {
  source = "../.."

  availability_zones     = var.availability_zones
  enable_ssm             = var.enable_ssm
  ipam_pool_id           = var.ipam_pool_id
  name                   = var.name
  private_subnet_netmask = var.private_subnet_netmask
  public_subnet_netmask  = var.public_subnet_netmask
  tags                   = var.tags
  transit_gateway_id     = var.transit_gateway_id
  vpc_cidr               = var.vpc_cidr
  vpc_netmask            = var.vpc_netmask

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/elb"            = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}
