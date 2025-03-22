
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
    }
    "dev" = {
      netmask = 24
    }
  }
}

## Note, due to the arns being dynamic this will be need to perfomed with a target,
## i.e vpc must exist before the share can be applied.
module "share_dev" {
  source = "../../modules/shared"

  name        = "dev"
  share       = { accounts = ["123456789012"] }
  subnet_arns = module.vpc.all_subnets_by_name["dev"].arns
  tags        = local.tags

  depends_on = [module.vpc]
}
