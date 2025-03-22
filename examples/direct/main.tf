
locals {
  tags = {
    "Environment" = "test"
    "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
    "Terraform"   = "true"
  }

}

## Alteratively you specifiy the subnets directly
module "vpc" {
  source = "../.."

  availability_zones = 3
  name               = "development"
  tags               = local.tags
  vpc_cidr           = "10.90.0.0/16"

  subnets = {
    prod = {
      netmask = 24
      tags    = merge(local.tags, {})
    }
    "dev" = {
      netmask = 24
    }
  }
}
