mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names = [
        "eu-west-1a",
        "eu-west-1b",
        "eu-west-1c"
      ]
    }
  }
}

run "basic" {
  command = plan

  variables {
    name                   = "test-vpc"
    private_subnet_netmask = 24
    tags = {
      "Environment" = "test"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
      "Terraform"   = "true"
    }
  }
}

