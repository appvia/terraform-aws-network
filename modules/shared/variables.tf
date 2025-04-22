
variable "name" {
  description = "The name used to prefix resources, and which should be unique"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to provision the subnets in"
  type        = string
}

variable "enable_parameter_store" {
  description = "Whether to share information via the SSM parameter store"
  type        = bool
  default     = true
}

variable "share" {
  description = "The principals to share the provisioned subnets with"
  type = object({
    accounts = optional(list(string), [])
    ## A list of accounts to share the subnets with
    organizational_units = optional(list(string), [])
    ## A list of organizational units to share the subnets with
  })
  default = {}
}

variable "parameter_store_prefix" {
  description = "The prefix to use for the SSM parameter store"
  type        = string
  default     = "/lz/network/shared"
}

variable "permitted_subnets" {
  description = "A collection of additional subnets to allow access to"
  type        = list(string)
  default     = []
}

variable "ram_share_prefix" {
  description = "The prefix to use for the RAM share name"
  type        = string
  default     = "network-share-"
}

variable "subnets" {
  description = "A collectionn of subnets to provision for the tenant"
  type = map(object({
    cidrs = list(string)
  }))
  default = {}
}

variable "routes" {
  description = "A collection of routes to add to the subnets"
  type = list(object({
    cidr = string
    ## The cidr block to provision the subnets (optional)
    carrier_gateway_id = optional(string, null)
    ## Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone.
    core_network_arn = optional(string, null)
    ## The Amazon Resource Name (ARN) of a core network.
    egress_only_gateway_id = optional(string, null)
    ## Identifier of a VPC Egress Only Internet Gateway.
    gateway_id = optional(string, null)
    ## Identifier of a VPC internet gateway or a virtual private gateway. Specify local when updating a previously imported local route.
    nat_gateway_id = optional(string, null)
    ## Identifier of a VPC NAT gateway.
    local_gateway_id = optional(string, null)
    ## Identifier of a Outpost local gateway.
    network_interface_id = optional(string, null)
    ## Identifier of an EC2 network interface.
    transit_gateway_id = optional(string, null)
    ## Identifier of an EC2 Transit Gateway.
    vpc_endpoint_id = optional(string, null)
    ## Identifier of a VPC Endpoint.
    vpc_peering_connection_id = optional(string, null)
    ## Identifier of a VPC peering connection.
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to apply to the NACL"
  type        = map(string)
}
