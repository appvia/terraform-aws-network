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

  mock_data "aws_route53_resolver_rules" {
    defaults = {
      resolver_rule_ids = [
        "rslvr-rr-1234567890",
      ]
    }
  }

  mock_data "aws_region" {
    defaults = {
      region = "eu-west-1"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "1234567890"
    }
  }
}

run "basic" {
  command = plan

  variables {
    name                   = "test-vpc"
    enable_ssm             = true
    private_subnet_netmask = 24
    tags = {
      "Environment" = "test"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
      "Terraform"   = "true"
    }
  }

  assert {
    condition     = module.vpc != null
    error_message = "Module should not be null"
  }

  assert {
    condition     = aws_vpc_endpoint.vpe_endpoints["ec2messages"] != null && aws_vpc_endpoint.vpe_endpoints["ec2messages"].service_name == "com.amazonaws.eu-west-1.ec2messages"
    error_message = "ec2messages endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.vpe_endpoints["ssm"] != null && aws_vpc_endpoint.vpe_endpoints["ssm"].service_name == "com.amazonaws.eu-west-1.ssm"
    error_message = "ssm endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.vpe_endpoints["ssmmessages"] != null && aws_vpc_endpoint.vpe_endpoints["ssmmessages"].service_name == "com.amazonaws.eu-west-1.ssmmessages"
    error_message = "ssmmessages endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.dynamodb[0] != null && aws_vpc_endpoint.dynamodb[0].service_name == "com.amazonaws.eu-west-1.dynamodb"
    error_message = "dynamodb endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0] != null && aws_vpc_endpoint.s3[0].service_name == "com.amazonaws.eu-west-1.s3"
    error_message = "s3 endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.dynamodb[0].vpc_endpoint_type == "Gateway"
    error_message = "dynamodb endpoint should be created"
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0].vpc_endpoint_type == "Gateway"
    error_message = "s3 endpoint should be created"
  }

  assert {
    condition     = aws_route53_resolver_rule_association.vpc_associations["rslvr-rr-1234567890"] != null
    error_message = "resolver rule association should be created"
  }

  assert {
    condition     = aws_route53_resolver_rule_association.vpc_associations["rslvr-rr-1234567890"].resolver_rule_id == "rslvr-rr-1234567890"
    error_message = "resolver rule association should have the correct values"
  }
}
