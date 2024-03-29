variable "availability_zones" {
  description = "The number of availability zone the network should be deployed into"
  type        = number
  default     = 2
}

variable "enable_ipam" {
  description = "Indicates the cidr block for the network should be assigned from IPAM"
  type        = bool
  default     = true
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

variable "ipam_pool_name" {
  description = "An optional pool name to use for IPAM pool to use"
  type        = string
  default     = ""
}

variable "ipam_pool_id" {
  description = "An optional pool id to use for IPAM pool to use"
  type        = string
  default     = ""
}

variable "name" {
  description = "Is the name of the network to provision"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "name must be a non-empty string"
  }

  validation {
    condition     = length(var.name) <= 10
    error_message = "name must not be longer than 10 characters"
  }
}

variable "nat_gateway_mode" {
  description = "The configuration mode of the NAT gateways"
  type        = string
  default     = "none"

  # Must be none, all_az, or single_az 
  validation {
    condition     = can(regex("^(none|all_az|single_az)$", var.nat_gateway_mode))
    error_message = "nat_gateway_mode must be non, all_az, or single_az"
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

variable "vpc_netmask" {
  description = "An optional range assigned to the VPC"
  type        = number
}
