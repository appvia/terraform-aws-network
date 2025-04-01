
variable "name" {
  description = "The name used to prefix resources, and which should be unique"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to provision the subnets in"
  type        = string
}

variable "share" {
  description = "The principals to share the provisioned subnets with"
  type = object({
    accounts = optional(list(string), [])
    ## A list of accounts to share the subnets with
    organizational_units = optional(list(string), [])
    ## A list of organizational units to share the subnets with
  })
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
    ## The cidr block to provision the subnets (optional)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to apply to the NACL"
  type        = map(string)
}
