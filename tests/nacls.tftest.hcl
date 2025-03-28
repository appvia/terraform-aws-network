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

run "check_nacl" {
  command = plan

  variables {
    name = "test-vpc"
    tags = {
      "Environment" = "test"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
      "Terraform"   = "true"
    }
    vpc_cidr = "10.100.0.0/21"

    subnets = {
      private = {
        netmask = 24
      }
    }

    nacl_rules = {
      private = {
        inbound_rules = [
          {
            cidr_block  = "10.100.0.0/24"
            from_port   = 22
            to_port     = 22
            protocol    = -1
            rule_action = "allow"
            rule_number = 100
          }
        ]
        outbound_rules = [
          {
            cidr_block  = "10.100.0.0/24"
            from_port   = 22
            to_port     = 22
            protocol    = -1
            rule_action = "allow"
            rule_number = 100
          }
        ]
      }
    }
  }

  ## Ensure VPC is created 
  assert {
    condition     = module.vpc != null
    error_message = "VPC should be created"
  }

  ## Ensure the NACLs are created 
  assert {
    condition     = module.nacls != null
    error_message = "NACLs should be created"
  }
}

run "check_nacl_rules" {
  command = plan

  module {
    source = "./modules/nacls"
  }

  variables {
    vpc_id       = "vpc-1234567890"
    subnet_count = 3
    subnet_ids   = ["subnet-1234567890", "subnet-1234567891", "subnet-1234567892"]
    inbound_rules = [
      {
        cidr_block  = "10.100.0.0/24"
        from_port   = 22
        to_port     = 22
        protocol    = -1
        rule_action = "allow"
        rule_number = 100
      }
    ]
    outbound_rules = [
      {
        cidr_block  = "10.100.0.0/24"
        from_port   = 22
        to_port     = 22
        protocol    = -1
        rule_action = "allow"
        rule_number = 100
      }
    ]
    tags = {
      "Environment" = "test"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
      "Terraform"   = "true"
    }
  }

  assert {
    condition     = aws_network_acl.inbound != null
    error_message = "Inbound NACL should be created"
  }

  assert {
    condition     = aws_network_acl.inbound.vpc_id == "vpc-1234567890"
    error_message = "Inbound NACL should be associated with the VPC"
  }

  assert {
    condition     = aws_network_acl.outbound != null
    error_message = "Outbound NACL should be created"
  }

  assert {
    condition     = length(aws_network_acl.inbound.tags) > 0
    error_message = "Inbound NACL should have the correct tags"
  }

  assert {
    condition     = aws_network_acl.outbound.vpc_id == "vpc-1234567890"
    error_message = "Outbound NACL should be associated with the VPC"
  }

  assert {
    condition     = length(aws_network_acl.outbound.tags) > 0
    error_message = "Outbound NACL should have the correct tags"
  }

  assert {
    error_message = "It should associate the inbound NACL with the subnets"
    condition     = aws_network_acl_association.inbound["0-0"].subnet_id == "subnet-1234567890"
  }

  assert {
    error_message = "It should associate the inbound NACL with the subnets"
    condition     = aws_network_acl_association.inbound["1-0"].subnet_id == "subnet-1234567891"
  }

  assert {
    error_message = "It should associate the inbound NACL with the subnets"
    condition     = aws_network_acl_association.inbound["2-0"].subnet_id == "subnet-1234567892"
  }

  assert {
    error_message = "It should associate the outbound NACL with the subnets"
    condition     = aws_network_acl_association.outbound["0-0"].subnet_id == "subnet-1234567890"
  }

  assert {
    error_message = "It should associate the outbound NACL with the subnets"
    condition     = aws_network_acl_association.outbound["1-0"].subnet_id == "subnet-1234567891"
  }

  assert {
    error_message = "It should associate the outbound NACL with the subnets"
    condition     = aws_network_acl_association.outbound["2-0"].subnet_id == "subnet-1234567892"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].cidr_block == "10.100.0.0/24"
    error_message = "Inbound NACL rule should have the correct values"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].egress == false
    error_message = "Inbound NACL rule should have the correct values"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].from_port == 22
    error_message = "Inbound NACL rule should have the correct values"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].protocol == "-1"
    error_message = "Inbound NACL rule should have the correct values"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].rule_action == "allow"
    error_message = "Inbound NACL rule should have the correct values"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["0-0"].rule_number == 100
    error_message = "Inbound NACL rule should have the correct values"
  }
}

