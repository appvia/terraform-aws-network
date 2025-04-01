
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

  mock_data "aws_vpc" {
    defaults = {
      id         = "vpc-12345678"
      cidr_block = "10.90.0.0/16"
    }
  }
}

run "validation_subnets_module" {
  command = plan

  module {
    source = "./modules/shared"
  }

  variables {
    name = "test"
    tags = {
      "Environment" = "test"
      "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
      "Terraform"   = "true"
    }
    share             = { accounts = ["123456789012"] }
    vpc_id            = "vpc-12345678"
    permitted_subnets = ["10.90.20.0/24"]

    subnets = {
      web = {
        cidrs = ["10.90.0.0/24", "10.90.1.0/24"]
      }
      app = {
        cidrs = ["10.90.10.0/24", "10.90.11.0/24"]
      }
    }

    routes = [
      {
        cidr       = "0.0.0.0/0"
        gateway_id = "tgw-12345678"
      }
    ]
  }

  assert {
    condition     = aws_subnet.subnets["app-10.90.10.0/24"].cidr_block == "10.90.10.0/24" && aws_subnet.subnets["app-10.90.11.0/24"].cidr_block == "10.90.11.0/24"
    error_message = "We expect the app subnets to be created"
  }

  assert {
    condition     = aws_subnet.subnets["app-10.90.10.0/24"].tags["Name"] == "test-app-eu-west-1a" && aws_subnet.subnets["app-10.90.11.0/24"].tags["Name"] == "test-app-eu-west-1b"
    error_message = "The expected name for the first app subnet was not found"
  }

  assert {
    condition     = aws_subnet.subnets["app-10.90.10.0/24"].availability_zone == "eu-west-1a" && aws_subnet.subnets["app-10.90.11.0/24"].availability_zone == "eu-west-1b"
    error_message = "We expect the app subnets to be created in the correct availability zones"
  }

  assert {
    condition     = aws_subnet.subnets["web-10.90.0.0/24"].cidr_block == "10.90.0.0/24" && aws_subnet.subnets["web-10.90.1.0/24"].cidr_block == "10.90.1.0/24"
    error_message = "We expect the web subnets to be created"
  }

  assert {
    condition     = aws_subnet.subnets["web-10.90.0.0/24"].tags["Name"] == "test-web-eu-west-1a" && aws_subnet.subnets["web-10.90.1.0/24"].tags["Name"] == "test-web-eu-west-1b"
    error_message = "We expect the web subnets to be created with the correct names"
  }

  assert {
    condition     = aws_subnet.subnets["web-10.90.0.0/24"].availability_zone == "eu-west-1a" && aws_subnet.subnets["web-10.90.1.0/24"].availability_zone == "eu-west-1b"
    error_message = "We expect the web subnets to be created in the correct availability zones"
  }

  assert {
    condition     = aws_network_acl.nacl != null && aws_network_acl.nacl.tags["Name"] == "acl-test" && aws_network_acl.nacl.vpc_id == "vpc-12345678"
    error_message = "The expected network acl was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["app-10.90.10.0/24"].cidr_block == "10.90.10.0/24" && aws_network_acl_rule.inbound["app-10.90.11.0/24"].cidr_block == "10.90.11.0/24"
    error_message = "The expected cidr block for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["app-10.90.10.0/24"].rule_action == "allow" && aws_network_acl_rule.inbound["app-10.90.11.0/24"].rule_action == "allow"
    error_message = "The expected allow rule action for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["app-10.90.10.0/24"].rule_number == 100 && aws_network_acl_rule.inbound["app-10.90.11.0/24"].rule_number == 101
    error_message = "The expected rule number for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["web-10.90.0.0/24"].cidr_block == "10.90.0.0/24" && aws_network_acl_rule.inbound["web-10.90.1.0/24"].cidr_block == "10.90.1.0/24"
    error_message = "The expected cidr block for the web subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["web-10.90.0.0/24"].rule_action == "allow" && aws_network_acl_rule.inbound["web-10.90.1.0/24"].rule_action == "allow"
    error_message = "The expected allow rule action for the web subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound["web-10.90.0.0/24"].rule_number == 102 && aws_network_acl_rule.inbound["web-10.90.1.0/24"].rule_number == 103
    error_message = "The expected rule number for the web subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound_default[0].cidr_block == "10.90.20.0/24" && aws_network_acl_rule.inbound_default[0].rule_action == "allow" && aws_network_acl_rule.inbound_default[0].rule_number == 150
    error_message = "The expected cidr block for the default subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound_deny_vpc.cidr_block == "10.90.0.0/16" && aws_network_acl_rule.inbound_deny_vpc.rule_action == "deny" && aws_network_acl_rule.inbound_deny_vpc.rule_number == 1000
    error_message = "The expected cidr block for the default subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.inbound_allow_all.cidr_block == "0.0.0.0/0" && aws_network_acl_rule.inbound_allow_all.rule_action == "allow" && aws_network_acl_rule.inbound_allow_all.rule_number == 1001
    error_message = "The expected cidr block for the default subnets was not found"
  }

  ## Outbound rules
  assert {
    condition     = aws_network_acl_rule.outbound["app-10.90.10.0/24"].cidr_block == "10.90.10.0/24" && aws_network_acl_rule.outbound["app-10.90.10.0/24"].rule_action == "allow" && aws_network_acl_rule.outbound["app-10.90.10.0/24"].rule_number == 200
    error_message = "The expected cidr block for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.outbound["app-10.90.11.0/24"].cidr_block == "10.90.11.0/24" && aws_network_acl_rule.outbound["app-10.90.11.0/24"].rule_action == "allow" && aws_network_acl_rule.outbound["app-10.90.11.0/24"].rule_number == 201
    error_message = "The expected cidr block for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.outbound["web-10.90.0.0/24"].cidr_block == "10.90.0.0/24" && aws_network_acl_rule.outbound["web-10.90.0.0/24"].rule_action == "allow" && aws_network_acl_rule.outbound["web-10.90.0.0/24"].rule_number == 202
    error_message = "The expected cidr block for the web subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.outbound["web-10.90.1.0/24"].cidr_block == "10.90.1.0/24" && aws_network_acl_rule.outbound["web-10.90.1.0/24"].rule_action == "allow" && aws_network_acl_rule.outbound["web-10.90.1.0/24"].rule_number == 203
    error_message = "The expected cidr block for the web subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.outbound_default[0].cidr_block == "10.90.20.0/24" && aws_network_acl_rule.outbound_default[0].rule_action == "allow" && aws_network_acl_rule.outbound_default[0].rule_number == 250
    error_message = "The expected cidr block for the default subnets was not found"
  }

  assert {
    condition     = aws_network_acl_rule.outbound_deny_vpc.cidr_block == "10.90.0.0/16" && aws_network_acl_rule.outbound_deny_vpc.rule_action == "deny" && aws_network_acl_rule.outbound_deny_vpc.rule_number == 2000
    error_message = "The expected the deny vpc rule was not found in the outbound rules"
  }

  assert {
    condition     = aws_network_acl_rule.outbound_allow_all.cidr_block == "0.0.0.0/0" && aws_network_acl_rule.outbound_allow_all.rule_action == "allow" && aws_network_acl_rule.outbound_allow_all.rule_number == 2001
    error_message = "The expected the allow all rule was not found in the outbound rules"
  }

  assert {
    condition     = aws_network_acl_association.nacl["app-10.90.10.0/24"] != null && aws_network_acl_association.nacl["app-10.90.11.0/24"] != null
    error_message = "The expected the network acl association for the app subnets was not found"
  }

  assert {
    condition     = aws_network_acl_association.nacl["web-10.90.0.0/24"] != null && aws_network_acl_association.nacl["web-10.90.1.0/24"] != null
    error_message = "The expected the network acl association for the web subnets was not found"
  }

  assert {
    condition     = aws_ram_resource_share.this != null && aws_ram_resource_share.this.name == "network-share-test"
    error_message = "The expected the ram resource share was not found"
  }

  assert {
    condition     = aws_ram_resource_association.this["app-10.90.10.0/24"] != null && aws_ram_resource_association.this["app-10.90.11.0/24"] != null
    error_message = "The expected the ram resource association for the app subnets was not found"
  }

  assert {
    condition     = aws_ram_resource_association.this["web-10.90.0.0/24"] != null && aws_ram_resource_association.this["web-10.90.1.0/24"] != null
    error_message = "The expected the ram resource association for the web subnets was not found"
  }

  assert {
    condition     = aws_ram_principal_association.accounts["123456789012"] != null
    error_message = "The expected the ram principal association for the accounts was not found"
  }

  assert {
    condition     = aws_route_table.current != null && aws_route_table.current.vpc_id == "vpc-12345678" && aws_route_table.current.tags["Name"] == "test"
    error_message = "The expected the route table was not found"
  }

  assert {
    condition     = aws_route_table_association.current["app-10.90.10.0/24"] != null
    error_message = "The expected the route table association for the app subnets was not found"
  }

  assert {
    condition     = aws_route_table_association.current["app-10.90.11.0/24"] != null && aws_route_table_association.current["app-10.90.10.0/24"] != null
    error_message = "The expected the route table association for the app subnets was not found"
  }

  assert {
    condition     = aws_route_table_association.current["web-10.90.0.0/24"] != null && aws_route_table_association.current["web-10.90.1.0/24"] != null
    error_message = "The expected the route table association for the web subnets was not found"
  }

  assert {
    condition     = aws_route.current["0.0.0.0/0"].gateway_id == "tgw-12345678"
    error_message = "The expected the route was not found"
  }
}
