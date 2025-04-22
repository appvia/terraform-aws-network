
locals {
  ## A map of the subnets and their tagging
  subnet_map = merge({
    for k, v in aws_subnet.subnets : v.id => v.tags
  })
}

## Provision the SSM parameter to store the JSON data
resource "aws_ssm_parameter" "current" {
  count = var.enable_parameter_store ? 1 : 0

  name        = format("%s/%s/%s", var.parameter_store_prefix, var.vpc_id, var.name)
  description = "Used to share resource related tags with other accounts"
  type        = "String"
  tier        = "Advanced"
  value       = jsonencode(local.subnet_map)
  tags        = local.tags
}

## Provision the RAM share to distribute the SSM parameter
resource "aws_ram_resource_share" "ssm_parameter_share" {
  count = var.enable_parameter_store ? 1 : 0

  allow_external_principals = false
  name                      = format("ssm-parameter-share-%s", var.name)
  tags                      = local.tags
}

## Associate the Parameter Store value with the RAM resource share
resource "aws_ram_resource_association" "ssm_parameter_association" {
  count = var.enable_parameter_store ? 1 : 0

  resource_share_arn = aws_ram_resource_share.ssm_parameter_share[0].arn
  resource_arn       = aws_ssm_parameter.current[0].arn
}

## Associate the principals with the RAM share
resource "aws_ram_principal_association" "ssm_parameter_accounts" {
  for_each = var.enable_parameter_store ? toset(var.share.accounts) : toset([])

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.ssm_parameter_share[0].arn
}

## Associate the principals with the RAM share
resource "aws_ram_principal_association" "ssm_parameter_organizational_units" {
  for_each = var.enable_parameter_store ? toset(var.share.organizational_units) : toset([])

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.ssm_parameter_share[0].arn
}
