variable "associate_hosted_ids" {
  description = "The list of hosted zone ids to associate with the VPC"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "The number of availability zone the network should be deployed into"
  type        = number
  default     = 2
}

variable "dns_query_log_retention" {
  description = "The number of days to retain DNS query logs"
  type        = number
  default     = 7
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

variable "enable_dynamodb_endpoint" {
  description = "Enable DynamoDB VPC Gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_dns_request_logging" {
  description = "Enable logging of DNS requests"
  type        = bool
  default     = false
}

variable "enable_private_endpoints" {
  description = "Indicates the network should provision private endpoints"
  type        = list(string)
  default     = []
}

variable "enable_route53_resolver_rules" {
  description = "Automatically associates any shared route53 resolver rules with the VPC"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "Enable S3 VPC Gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_ssm" {
  description = "Indicates we should provision SSM private endpoints"
  type        = bool
  default     = false
}

variable "enable_transit_gateway_appliance_mode" {
  description = "Indicates the network should be connected to a transit gateway in appliance mode"
  type        = bool
  default     = false
}

variable "enable_transit_gateway_subnet_natgw" {
  description = "Indicates if the transit gateway subnets should be connected to a nat gateway"
  type        = bool
  default     = false
}

variable "exclude_route53_resolver_rules" {
  description = "List of resolver rules to exclude from association"
  type        = list(string)
  default     = []
}

variable "ipam_pool_id" {
  description = "An optional pool id to use for IPAM pool to use"
  type        = string
  default     = null
}

variable "nacl_rules" {
  description = "Map of NACL rules to apply to different subnet types. Each rule requires from_port, to_port, protocol, rule_action, cidr_block, and rule_number"
  type = map(object({
    inbound = list(object({
      cidr_block      = string
      from_port       = optional(number, null)
      icmp_code       = optional(number, 0)
      icmp_type       = optional(number, 0)
      ipv6_cidr_block = optional(string, null)
      protocol        = optional(number, -1)
      rule_action     = optional(string, "allow")
      rule_number     = number
      to_port         = optional(number, null)
    }))
    outbound = list(object({
      cidr_block      = string
      from_port       = optional(number, null)
      icmp_code       = optional(number, 0)
      icmp_type       = optional(number, 0)
      ipv6_cidr_block = optional(string, null)
      protocol        = optional(number, -1)
      rule_action     = optional(string, "allow")
      rule_number     = number
      to_port         = optional(number, null)
    }))
  }))
  default = {}
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
    error_message = "nat_gateway_mode must be none, all_azs, or single_az"
  }
}

variable "private_subnet_netmask" {
  description = "The netmask for the private subnets"
  type        = number
  default     = 0
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_netmask" {
  description = "The netmask for the public subnets"
  type        = number
  default     = 0
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Additional subnets to create in the network, keyed by the subnet name"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "If enabled, and not lookup is disabled, the transit gateway id to connect to"
  type        = string
  default     = null
}

variable "transit_gateway_routes" {
  description = "If enabled, this is the cidr block to route down the transit gateway"
  type        = map(string)
  default = {
    "private" = "10.0.0.0/8"
  }
}

variable "transit_subnet_tags" {
  description = "Additional tags for the transit subnets"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "An optional cidr block to assign to the VPC (if not using IPAM)"
  type        = string
  default     = null
}

variable "vpc_instance_tenancy" {
  description = "The name of the VPC to create"
  type        = string
  default     = "default"
}

variable "vpc_netmask" {
  description = "An optional range assigned to the VPC"
  type        = number
  default     = null
}
