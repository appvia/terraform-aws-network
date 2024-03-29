#check "vpc_cidr" {
#  assert {
#    condition     = var.enable_ipam && var.vpc_netmask == null
#    error_message = "When 'enable_ipam' is true, 'vpc_netmask' must be specified"
#  }
#
#  assert {
#    condition     = var.enable_ipam && var.vpc_cidr != ""
#    error_message = "When 'enable_ipam' is true, 'vpc_cidr' must be empty"
#  }
#
#  assert {
#    condition     = !var.enable_ipam && var.vpc_cidr == ""
#    error_message = "When 'enable_ipam' is false, 'vpc_cidr' must be specified"
#  }
#}
#
#check "nat_gateway" {
#  assert {
#    condition     = var.enable_nat_gateway && var.nat_gateway_mode == ""
#    error_message = "When 'enable_nat_gateway' is true, 'nat_gateway_mode' must be specified"
#  }
#
#  assert {
#    condition     = var.enable_nat_gateway && var.nat_gateway_mode != "single" && var.nat_gateway_mode != "all_azs"
#    error_message = "When 'enable_nat_gateway' is true, 'nat_gateway_mode' must be 'single' or 'all_azs'"
#  }
#}
