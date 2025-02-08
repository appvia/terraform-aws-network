
## Provision a RAM resource share
resource "aws_ram_resource_share" "this" {
  name                      = var.name
  tags                      = var.tags
  allow_external_principals = var.allow_external_principals
}

## Associate the resources to the resource share 
module "resource_associations" {
  source   = "../ram_resources"
  for_each = { for resource in var.resources : resource.name => resource }

  resource_arn       = each.value.resource_arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

## Associate the principals to the resource share 
module "principal_associations" {
  source   = "../ram_associations"
  for_each = toset(var.principals)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
