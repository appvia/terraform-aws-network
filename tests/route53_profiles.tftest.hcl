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

  mock_data "aws_route53profiles_profiles" {
    defaults = {
      profiles = []
    }
  }
}

run "a_no_name" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-one"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-one"
          name         = "one"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    route53_profile_name          = null
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case a: expected no association when profile name is unset"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case a: expected route53_profile_id output to be null"
  }
}

run "b_name_found" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-one"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-one"
          name         = "one"
          share_status = "SHARED_WITH_ME"
        },
        {
          id           = "rp-two"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-two"
          name         = "two"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    route53_profile_name          = "one"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 1
    error_message = "Case b: expected association when profile name is found"
  }

  assert {
    condition     = aws_route53profiles_association.route53_profile[0].profile_id == "rp-one"
    error_message = "Case b: association profile_id should be rp-one"
  }

  assert {
    condition     = output.route53_profile_id == "rp-one"
    error_message = "Case b: expected route53_profile_id output to be rp-one"
  }
}

run "c_name_not_found" {
  command = plan

  override_data {
    target = data.aws_route53profiles_profiles.current
    values = {
      profiles = [
        {
          id           = "rp-a"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-a"
          name         = "a"
          share_status = "SHARED_WITH_ME"
        },
        {
          id           = "rp-b"
          arn          = "arn:aws:route53profiles:eu-west-1:1234567890:profile/rp-b"
          name         = "b"
          share_status = "SHARED_WITH_ME"
        }
      ]
    }
  }

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    route53_profile_name          = "missing"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case c: expected no association when profile name is not found"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case c: expected route53_profile_id output to be null"
  }
}

run "d_name_not_found_empty_profiles" {
  command = plan

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    route53_profile_name          = "one"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case d: expected no association when no profiles are discovered"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case d: expected route53_profile_id output to be null"
  }
}
