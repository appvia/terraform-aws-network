
variable "name" {
  description = "The name of the subnets to create the NACL for"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to create the NACL in"
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets to create the NACL for"
  type        = number
}

variable "subnet_ids" {
  description = "The subnet IDs to apply the NACL to"
  type        = list(string)
}

variable "inbound_rules" {
  description = "The inbound rules to apply to the NACL"
  type = list(object({
    cidr_block      = string
    from_port       = number
    icmp_code       = optional(number, 0)
    icmp_type       = optional(number, 0)
    ipv6_cidr_block = optional(string, null)
    protocol        = optional(number, -1)
    rule_action     = string
    rule_number     = number
    to_port         = number
  }))
  default = []
}

variable "outbound_rules" {
  description = "The outbound rules to apply to the NACL"
  type = list(object({
    cidr_block      = string
    from_port       = number
    icmp_code       = optional(number, 0)
    icmp_type       = optional(number, 0)
    ipv6_cidr_block = optional(string, null)
    protocol        = optional(number, -1)
    rule_action     = string
    rule_number     = number
    to_port         = number
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to apply to the NACL"
  type        = map(string)
}
