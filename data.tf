
# Get the current region
data "aws_region" "current" {}

### Find any forwarding rules which have been shared to us
data "aws_route53_resolver_rules" "current" {
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
}

data "aws_availability_zones" "current" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
