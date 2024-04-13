
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

variable "enable_transit_gateway" {
  description = "Indicates the network should provison nat gateways"
  type        = bool
  default     = false
}

variable "enable_ssm" {
  description = "Indicates we should provision SSM private endpoints"
  type        = bool
  default     = false
}

variable "name" {
  description = "Is the name of the network to provision"
  type        = string
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

variable "vpc_cidr" {
  description = "An optional cidr block to assign to the VPC (if not using IPAM)"
  type        = string
  default     = null
}
