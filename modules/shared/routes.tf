## Related to the route tables

## Provision a route table for the subnets
resource "aws_route_table" "current" {
  vpc_id = var.vpc_id
  tags   = merge(local.tags, { Name = var.name })
}

## Associate all the subnets with the routing table
resource "aws_route_table_association" "current" {
  for_each = aws_subnet.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.current.id
}

## Provision routing entries
resource "aws_route" "current" {
  for_each = {
    for idx, v in var.routes : v.cidr => v
  }

  carrier_gateway_id        = each.value.carrier_gateway_id
  core_network_arn          = each.value.core_network_arn
  destination_cidr_block    = each.value.cidr
  egress_only_gateway_id    = each.value.egress_only_gateway_id
  gateway_id                = each.value.gateway_id
  local_gateway_id          = each.value.local_gateway_id
  nat_gateway_id            = each.value.nat_gateway_id
  network_interface_id      = each.value.network_interface_id
  route_table_id            = aws_route_table.current.id
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
}
