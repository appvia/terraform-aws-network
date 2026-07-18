
## Provision the S3 endpoint
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  route_table_ids   = local.private_route_table_ids
  service_name      = "com.amazonaws.${local.region}.s3"
  tags              = merge(local.tags, { Name = "vpce-s3-${var.name}" })
  vpc_endpoint_type = "Gateway"
  vpc_id            = module.vpc.vpc_attributes.id
}

## Provision the DynamoDB endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  route_table_ids   = local.private_route_table_ids
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  tags              = merge(local.tags, { Name = "vpce-dynamodb-${var.name}" })
  vpc_endpoint_type = "Gateway"
  vpc_id            = module.vpc.vpc_attributes.id
}

## Provision the security groups for the private links
module "private_links" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"
  count   = length(local.enabled_endpoints) > 0 ? 1 : 0

  description = "Provides the security groups for the private links access"
  name        = "vpce-${var.name}"
  tags        = local.tags
  vpc_id      = module.vpc.vpc_attributes.id

  ## Keys must be known at plan time, so we derive them from the statically
  ## configured availability zone count rather than the apply-time subnet list.
  ingress_rules = {
    for idx in range(local.private_subnet_count) : tostring(idx) => {
      cidr_ipv4   = local.private_subnet_cidrs[idx]
      description = "Allow HTTPS from the private subnet in AZ ${idx}"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
    }
  }
}

## Provision any private endpoints
resource "aws_vpc_endpoint" "vpe_endpoints" {
  for_each = toset(local.enabled_endpoints)

  private_dns_enabled = true
  security_group_ids  = [module.private_links[0].id]
  service_name        = "com.amazonaws.${local.region}.${each.value}"
  subnet_ids          = local.private_subnet_ids
  tags                = merge(local.tags, { Name = "vpce-${each.value}-${var.name}" })
  vpc_endpoint_type   = "Interface"
  vpc_id              = module.vpc.vpc_attributes.id
}
