variable "name" {
  description = "Name of the resource share"
  type        = string
}

variable "allow_external_principals" {
  description = "Allow external principals to associate with the resource share."
  type        = bool
  default     = false
}

variable "principals" {
  description = "List of principals to associate with the resource share."
  type        = list(string)
  default     = []
}

variable "resources" {
  description = "Schema list of resources to associate to the resource share"
  type = list(object({
    name         = string
    resource_arn = string
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to assign to the resource share"
  type        = map(string)
}
