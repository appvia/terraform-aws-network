
variable "availability_zones" {
  description = "The number of availability zone the network should be deployed into"
  type        = number
  default     = 2
}

variable "enable_ipam" {
  description = "Indicates the cidr block for the network should be assigned from IPAM"
  type        = bool
  default     = false
}

variable "enable_transit_gateway" {
  description = "Indicates the network should provison nat gateways"
  type        = bool
  default     = true
}

variable "enable_ssm" {
  description = "Indicates we should provision SSM private endpoints"
  type        = bool
  default     = false
}

variable "ipam_pool_id" {
  description = "The id of the IPAM pool to use for the network"
  type        = string
  default     = null
}

variable "name" {
  description = "Is the name of the network to provision"
  type        = string
  default     = "test-vpc"
}

variable "private_subnet_netmask" {
  description = "The netmask for the private subnets"
  type        = number
  default     = 24
}

variable "public_subnet_netmask" {
  description = "The netmask for the public subnets"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    "Environment" = "test"
    "GitRepo"     = "https://github.com/appvia/terraform-aws-network"
    "Terraform"   = "true"
  }
}

variable "transit_gateway_id" {
  description = "If enabled, and not lookup is disabled, the transit gateway id to connect to"
  type        = string
  default     = "tgw-04ad8f026be8b7eb6"
}

variable "vpc_cidr" {
  description = "An optional cidr block to assign to the VPC (if not using IPAM)"
  type        = string
  default     = "10.88.0.0/21"
}

variable "vpc_netmask" {
  description = "The netmask for the VPC when using IPAM"
  type        = number
  default     = null
}
