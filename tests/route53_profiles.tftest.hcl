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

run "a_no_profile_discovery_disabled" {
  command = plan

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    enable_route53_profiles_rules = false
    route53_profile_id            = null
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case a: expected no route53 profile association"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case a: expected route53_profile_id output to be null"
  }
}

run "b_explicit_profile_discovery_disabled" {
  command = plan

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    enable_route53_profiles_rules = false
    route53_profile_id            = "rp-explicit"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 1
    error_message = "Case b: expected route53 profile association"
  }

  assert {
    condition     = aws_route53profiles_association.route53_profile[0].profile_id == "rp-explicit"
    error_message = "Case b: association profile_id should be rp-explicit"
  }

  assert {
    condition     = output.route53_profile_id == "rp-explicit"
    error_message = "Case b: expected route53_profile_id output to be rp-explicit"
  }
}

run "c_discovery_enabled_no_profiles" {
  command = plan

  variables {
    name                          = "test-vpc"
    private_subnet_netmask        = 24
    enable_route53_profiles_rules = true
    route53_profile_id            = null
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case c: expected no association when no profiles discovered"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case c: expected route53_profile_id output to be null"
  }
}

run "d_discovery_enabled_one_profile" {
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
    enable_route53_profiles_rules = true
    route53_profile_id            = null
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 1
    error_message = "Case d: expected association when exactly one profile is discovered"
  }

  assert {
    condition     = aws_route53profiles_association.route53_profile[0].profile_id == "rp-one"
    error_message = "Case d: association profile_id should be rp-one"
  }

  assert {
    condition     = output.route53_profile_id == "rp-one"
    error_message = "Case d: expected route53_profile_id output to be rp-one"
  }
}

run "e_discovery_enabled_multiple_profiles" {
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
    enable_route53_profiles_rules = true
    route53_profile_id            = null
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case e: expected no association when multiple profiles are discovered"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case e: expected route53_profile_id output to be null"
  }
}

run "f1_explicit_profile_found_among_multiple" {
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
    enable_route53_profiles_rules = true
    route53_profile_id            = "rp-a"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 1
    error_message = "Case f1: expected association when explicit profile exists in discovered list"
  }

  assert {
    condition     = aws_route53profiles_association.route53_profile[0].profile_id == "rp-a"
    error_message = "Case f1: association profile_id should be rp-a"
  }

  assert {
    condition     = output.route53_profile_id == "rp-a"
    error_message = "Case f1: expected route53_profile_id output to be rp-a"
  }
}

run "f2_explicit_profile_not_found_among_multiple" {
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
    enable_route53_profiles_rules = true
    route53_profile_id            = "rp-missing"
    enable_route53_resolver_rules = false
    tags = {
      Environment = "test"
      GitRepo     = "https://github.com/appvia/terraform-aws-network"
      Terraform   = "true"
    }
  }

  assert {
    condition     = length(aws_route53profiles_association.route53_profile) == 0
    error_message = "Case f2: expected no association when explicit profile is not in discovered list"
  }

  assert {
    condition     = output.route53_profile_id == null
    error_message = "Case f2: expected route53_profile_id output to be null"
  }
}
