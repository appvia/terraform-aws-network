
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

  availability_zones            = 2
  enable_ssm                    = false
  enable_route53_resolver_rules = false
  name                          = "operations"
  tags                          = local.tags
  vpc_cidr                      = "10.100.0.0/21"

  subnets = {
    private = {
      netmask = 24
    }
  }

  nacl_rules = {
    private = {
      inbound = [
        {
          cidr_block  = "10.100.0.0/24"
          from_port   = 22
          to_port     = 22
          protocol    = -1
          rule_action = "allow"
          rule_number = 50
        }
      ]
      outbound = [
        {
          cidr_block  = "10.100.0.0/24"
          from_port   = 22
          to_port     = 22
          protocol    = -1
          rule_action = "allow"
          rule_number = 50
        }
      ]
    }
  }
}
