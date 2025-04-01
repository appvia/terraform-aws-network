
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
}

## Note, due to the arns being dynamic this will be need to perfomed with a target,
## i.e vpc must exist before the share can be applied.
module "subnets" {
  source = "../../modules/shared"

  name   = "dev"
  share  = { accounts = ["123456789012"] }
  tags   = local.tags
  vpc_id = module.vpc.vpc_id

  permitted_subnets = [
    "10.90.20.0/24",
  ]

  subnets = {
    web = {
      cidrs = ["10.90.0.0/24", "10.90.1.0/24"]
    }
    app = {
      cidrs = ["10.90.10.0/24", "10.90.11.0/24"]
    }
  }
}

