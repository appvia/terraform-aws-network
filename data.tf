
# Get the current region 
data "aws_region" "current" {}

### Find any forwarding rules which have been shared to us 
data "aws_route53_resolver_rules" "current" {
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
}

