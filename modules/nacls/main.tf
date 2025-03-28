
## Provision the inbound NACL
resource "aws_network_acl" "nacl" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = var.name })
}

## Provision the outbound NACL
## Provision the inbound NACL rules
resource "aws_network_acl_rule" "inbound" {
  for_each = local.inbound

  cidr_block      = each.value.rule.cidr_block
  egress          = false
  from_port       = each.value.rule.from_port
  icmp_code       = each.value.rule.icmp_code
  icmp_type       = each.value.rule.icmp_type
  ipv6_cidr_block = each.value.rule.ipv6_cidr_block
  network_acl_id  = aws_network_acl.nacl.id
  protocol        = each.value.rule.protocol
  rule_action     = each.value.rule.rule_action
  rule_number     = each.value.rule.rule_number
  to_port         = each.value.rule.to_port
}

## Provision the outbound NACL rules
resource "aws_network_acl_rule" "outbound" {
  for_each = local.outbound

  cidr_block      = each.value.rule.cidr_block
  egress          = true
  from_port       = each.value.rule.from_port
  icmp_code       = each.value.rule.icmp_code
  icmp_type       = each.value.rule.icmp_type
  ipv6_cidr_block = each.value.rule.ipv6_cidr_block
  network_acl_id  = aws_network_acl.nacl.id
  protocol        = each.value.rule.protocol
  rule_action     = each.value.rule.rule_action
  rule_number     = each.value.rule.rule_number
  to_port         = each.value.rule.to_port
}

## Associate the inbound NACL with the subnets
resource "aws_network_acl_association" "nacl" {
  for_each = local.inbound

  network_acl_id = aws_network_acl.nacl.id
  subnet_id      = each.value.id
}
