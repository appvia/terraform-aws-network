
## Provision a the subnets for the tenant
resource "aws_subnet" "subnets" {
  for_each = local.subnets

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  tags              = merge(local.tags, { Name = each.value.name })
  vpc_id            = var.vpc_id
}

## Provision the network acl for ALL the subnets
resource "aws_network_acl" "nacl" {
  tags   = merge(local.tags, { Name = format("acl-%s", var.name) })
  vpc_id = var.vpc_id
}

## Provision the inbound NACL rules
resource "aws_network_acl_rule" "inbound" {
  for_each = local.network_inbound_acls

  cidr_block     = each.value.cidr_block
  egress         = false
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = each.value.rule_number
}

## Ensure we allow the default subnets
resource "aws_network_acl_rule" "inbound_default" {
  count = length(var.permitted_subnets)

  cidr_block     = element(var.permitted_subnets, count.index)
  egress         = false
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 150 + count.index
}

## Allow the default inbound rules
resource "aws_network_acl_rule" "inbound_deny_vpc" {
  cidr_block     = data.aws_vpc.current.cidr_block
  egress         = false
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "deny"
  rule_number    = 1000
}

## Allow everything else to traverse
resource "aws_network_acl_rule" "inbound_allow_all" {
  cidr_block     = "0.0.0.0/0"
  egress         = false
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 1001
}

## Provision the outbound NACL rules
resource "aws_network_acl_rule" "outbound" {
  for_each = local.network_outbound_acls

  cidr_block     = each.value.cidr_block
  egress         = true
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = each.value.rule_number
}

## Ensure we allow the default subnets outbound
resource "aws_network_acl_rule" "outbound_default" {
  count = length(var.permitted_subnets)

  cidr_block     = element(var.permitted_subnets, count.index)
  egress         = true
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 250 + count.index
}

## Allow the default outbound rules
resource "aws_network_acl_rule" "outbound_deny_vpc" {
  cidr_block     = data.aws_vpc.current.cidr_block
  egress         = true
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "deny"
  rule_number    = 2000
}

## Allow everything else to traverse
resource "aws_network_acl_rule" "outbound_allow_all" {
  cidr_block     = "0.0.0.0/0"
  egress         = true
  network_acl_id = aws_network_acl.nacl.id
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 2001
}

## Associate the inbound NACL with the subnets
resource "aws_network_acl_association" "nacl" {
  for_each = aws_subnet.subnets

  network_acl_id = aws_network_acl.nacl.id
  subnet_id      = each.value.id
}

