# Get the current region
data "aws_region" "current" {}
# Get the account id
data "aws_caller_identity" "current" {}

