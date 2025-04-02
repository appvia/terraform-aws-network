## Related to the DNS request logging and resolver rules

## Enable DNS request logging if required
resource "aws_cloudwatch_log_group" "dns_query_logs" {
  count = var.enable_dns_request_logging ? 1 : 0

  name              = "/aws/route53/${var.name}/dns-query-logs"
  retention_in_days = var.dns_query_log_retention
  tags              = local.tags
}

## Create the DNS query log config
resource "aws_route53_resolver_query_log_config" "dns_query_log_config" {
  count = var.enable_dns_request_logging ? 1 : 0

  name            = "${var.name}-dns-query-logs"
  destination_arn = aws_cloudwatch_log_group.dns_query_logs[0].arn
}

## Associate the DNS query log config with the VPC
resource "aws_route53_resolver_query_log_config_association" "dns_query_log_association" {
  count = var.enable_dns_request_logging ? 1 : 0

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.dns_query_log_config[0].id
  resource_id                  = module.vpc.vpc_attributes.id
}

## Associate any resolver rules with the vpc if required
resource "aws_route53_resolver_rule_association" "vpc_associations" {
  for_each = var.enable_route53_resolver_rules ? toset(local.resolver_rules) : []

  resolver_rule_id = each.value
  vpc_id           = module.vpc.vpc_attributes.id
}

## Associate the route53 hosted zone with the VPC
resource "aws_route53_zone_association" "association" {
  for_each = toset(var.associate_hosted_ids)

  vpc_id  = module.vpc.vpc_attributes.id
  zone_id = each.value
}
