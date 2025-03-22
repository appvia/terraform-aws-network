
locals {
  tags = {
    "Environment" = "test"
    "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
    "Terraform"   = "true"
  }

}

## Provision a VPC with public and private subnets
module "vpc" {
  source = "../.."

  availability_zones     = 3
  enable_ssm             = true
  ipam_pool_id           = "ipam-pool-id"
  name                   = "operations"
  private_subnet_netmask = 24
  public_subnet_netmask  = 24
  tags                   = local.tags
  vpc_cidr               = "10.100.0.0/21"

  private_subnet_tags = {
    "kubernetes.io/cluster/operations" = "owned"
    "kubernetes.io/role/elb"           = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/operations" = "owned"
    "kubernetes.io/role/internal-elb"  = "1"
  }
}
