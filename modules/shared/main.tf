
## Provision a AWS RAM share, to distribute the subnets to the accounts
module "ram_share" {
  source  = "appvia/ram/aws"
  version = "0.0.1"

  allow_external_principals = false
  name                      = local.ram_share_name
  principals                = local.principals
  resource_arns             = var.subnet_arns
  tags                      = merge(var.tags, local.tags)
}
