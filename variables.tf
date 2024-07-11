variable "availability_zones" {
  description = "The number of availability zone the network should be deployed into"
  type        = number
  default     = 2
}

variable "additional_subnets" {
  description = "Additional subnets to create in the network"
  type        = map(any)
  default     = null
}

variable "enable_ipam" {
  description = "Indicates the cidr block for the network should be assigned from IPAM"
  type        = bool
  default     = true
}

variable "enable_route53_resolver_rules" {
  description = "Automatically associates any shared route53 resolver rules with the VPC"
  type        = bool
  default     = true
}

variable "exclude_route53_resolver_rules" {
  description = "List of resolver rules to exclude from association"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Indicates the network should provison nat gateways"
  type        = bool
  default     = false
}

variable "enable_transit_gateway" {
  description = "Indicates the network should provison nat gateways"
  type        = bool
  default     = false
}

variable "enable_transit_gateway_subnet_natgw" {
  description = "Indicates if the transit gateway subnets should be connected to a nat gateway"
  type        = bool
  default     = false
}

variable "enable_default_route_table_association" {
  description = "Indicates the transit gateway default route table should be associated with the subnets"
  type        = bool
  default     = true
}

variable "enable_default_route_table_propagation" {
  description = "Indicates the transit gateway default route table should be propagated to the subnets"
  type        = bool
  default     = true
}

variable "enable_transit_gateway_appliance_mode" {
  description = "Indicates the network should be connected to a transit gateway in appliance mode"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Indicates the network should provision private endpoints"
  type        = list(string)
  default     = []
}

variable "enable_ssm" {
  description = "Indicates we should provision SSM private endpoints"
  type        = bool
  default     = false
}

variable "ipam_pool_id" {
  description = "An optional pool id to use for IPAM pool to use"
  type        = string
  default     = null
}

variable "name" {
  description = "Is the name of the network to provision"
  type        = string
}

variable "nat_gateway_mode" {
  description = "The configuration mode of the NAT gateways"
  type        = string
  default     = "none"

  validation {
    condition     = can(regex("^(none|all_azs|single_az)$", var.nat_gateway_mode))
    error_message = "nat_gateway_mode must be non, all_azs, or single_az"
  }
}

variable "private_subnet_netmask" {
  description = "The netmask for the private subnets"
  type        = number

  validation {
    condition     = var.private_subnet_netmask > 0 && var.private_subnet_netmask <= 28
    error_message = "private_subnet_netmask must be between 1 and 28"
  }
}

variable "public_subnet_netmask" {
  description = "The netmask for the public subnets"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "If enabled, and not lookup is disabled, the transit gateway id to connect to"
  type        = string
  default     = ""
}

variable "transit_gateway_routes" {
  description = "If enabled, this is the cidr block to route down the transit gateway"
  type        = map(string)
  default = {
    "private" = "10.0.0.0/8"
  }
}

variable "vpc_cidr" {
  description = "An optional cidr block to assign to the VPC (if not using IPAM)"
  type        = string
  default     = null
}

variable "vpc_netmask" {
  description = "An optional range assigned to the VPC"
  type        = number
  default     = null
}

variable "vpc_instance_tenancy" {
  description = "The name of the VPC to create"
  type        = string
  default     = "default"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "transit_subnet_tags" {
  description = "Additional tags for the transit subnets"
  type        = map(string)
  default     = {}
}
