
variable "name" {
  description = "A name to associate with the resources"
  type        = string
}

variable "ram_share_prefix" {
  description = "The prefix to use for the RAM share name"
  type        = string
  default     = "network-share-"
}

variable "share" {
  description = "The principals to share the subnets with"
  type = object({
    accounts = optional(list(string), [])
    # A list of accounts to share the subnets with
    organizational_units = optional(list(string), [])
    # A list of organization units to share the subnets with
  })
  default = {}
}

variable "subnet_arns" {
  description = "A collection of subnets to share with one or more principals"
  type        = list(string)
}

variable "tags" {
  description = "A collection of tags to apply to the resources"
  type        = map(string)
}
