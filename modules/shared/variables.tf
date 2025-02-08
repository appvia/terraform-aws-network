variable "associated_route53_zones" {
  description = "A list of route53 zones to associate with the VPC"
  type        = list(string)
  default     = []
}

variable "associated_resolver_rules" {
  description = "A list of resolver rules to associate with the VPC"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "The number of availability zone the network should be deployed into"
  type        = number
  default     = 2
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

variable "subnets" {
  description = "A collection of subnets to provison, and rules to distribute to accounts"
  type = map(object({
    availability_zones = optional(number, null)
    # The availability zones to deploy the subnet into, else default to vpc availability zones
    netmask = optional(number, null)
    # The netmask for the subnet each of the subnets against the availability zones
    tags = optional(map(string), null)
    # Additional tags for the subnets
    shared = optional(object({
      accounts = optional(list(string), null)
      # A list of accounts to share the subnets with
      organization_units = optional(list(string), null)
      # A list of organization units to share the subnets with
    }), null)
  }))
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

variable "transit_subnet_tags" {
  description = "Additional tags for the transit subnets"
  type        = map(string)
  default     = {}
}
