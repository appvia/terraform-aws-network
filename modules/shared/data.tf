
## Find the VPC using the vpc id
data "aws_vpc" "current" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

## Find the availability zones in the VPC
data "aws_availability_zones" "current" {}
