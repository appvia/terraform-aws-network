# Get the current region 
data "aws_region" "current" {}

## Find any forwarding rules which have been shared to us 
data "aws_route53_resolver_rules" "current" {
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
}

## Lookup the IPAM by protocol
data "aws_vpc_ipam_pool" "current" {
  count = var.enable_ipam ? 1 : 0

  dynamic "filter" {
    for_each = var.ipam_pool_name != "" ? [1] : []

    content {
      name   = "description"
      values = [var.ipam_pool_name]
    }
  }

  dynamic "filter" {
    for_each = var.ipam_pool_id != "" ? [1] : []

    content {
      name   = "id"
      values = [var.ipam_pool_id]
    }
  }
}

## Provision the VPC for VPN
module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = "= 4.4.2"

  name                     = var.name
  az_count                 = var.availability_zones
  cidr_block               = var.vpc_cidr
  subnets                  = local.subnets
  tags                     = var.tags
  transit_gateway_id       = local.transit_gateway_id
  transit_gateway_routes   = local.transit_routes
  vpc_instance_tenancy     = var.vpc_instance_tenancy
  vpc_enable_dns_hostnames = true
  vpc_enable_dns_support   = true
  vpc_ipv4_ipam_pool_id    = local.ipam_pool_id
  vpc_ipv4_netmask_length  = var.vpc_netmask
}

## Associate any resolver rules with the vpc if required 
resource "aws_route53_resolver_rule_association" "vpc_associations" {
  for_each = var.enable_route53_resolver_rules ? local.resolver_rules : {}

  resolver_rule_id = each.value
  vpc_id           = module.vpc.vpc_attributes.id
}

## Provision the security groups for the private links 
module "private_links" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"
  count   = length(local.enabled_endpoints) > 0 ? 1 : 0

  description         = "Provides the security groups for the private links access"
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = local.private_subnet_cidrs
  name                = "private-links-${var.name}"
  tags                = var.tags
  vpc_id              = module.vpc.vpc_attributes.id
}

## Provision any private endpoints
resource "aws_vpc_endpoint" "vpe_endpoints" {
  for_each = toset(local.enabled_endpoints)

  private_dns_enabled = true
  security_group_ids  = [module.private_links[0].security_group_id]
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  subnet_ids          = local.private_subnet_ids
  tags                = merge(var.tags, { Name = "vpe-${each.value}-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = module.vpc.vpc_attributes.id
}

