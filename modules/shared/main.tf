
## Provision a AWS RAM share, to distribute the subnets to the accounts
resource "aws_ram_resource_share" "this" {
  name                      = local.ram_share_name
  allow_external_principals = false
  permission_arns           = []
  tags                      = local.tags
}

## Associate the subnets with the RAM share
resource "aws_ram_resource_association" "this" {
  for_each = { for idx, arn in var.subnet_arns : idx => arn }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

## Associate the principals with the RAM share
resource "aws_ram_principal_association" "org" {
  for_each = toset(local.principals)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
