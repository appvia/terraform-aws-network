## Related the RAM sharing

## Provision a AWS RAM share, to distribute the subnets to the accounts
resource "aws_ram_resource_share" "this" {
  name                      = local.ram_share_name
  allow_external_principals = false
  permission_arns           = ["arn:aws:ram::aws:permission/AWSRAMDefaultPermissionSubnet"]
  tags                      = local.tags
}

## Associate the subnets with the RAM share
resource "aws_ram_resource_association" "this" {
  for_each = aws_subnet.subnets

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

## Associate the principals with the RAM share
resource "aws_ram_principal_association" "accounts" {
  for_each = toset(var.share.accounts)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

## Associate the principals with the RAM share
resource "aws_ram_principal_association" "organizational_units" {
  for_each = toset(var.share.organizational_units)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
