<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-network/blob/main/appvia_banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/network/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-network/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-network.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-network/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-network.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-network/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Network

## Description

The purpose of this module is to provide a consistent way to provision a VPC and associated resources in AWS.

## Usage

Add example usage here

```hcl
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"

  availability_zones                    = var.availability_zones
  enable_ipam                           = var.enable_ipam
  enable_ssm                            = var.enable_ssm
  enable_transit_gateway                = var.enable_transit_gateway
  enable_transit_gateway_appliance_mode = true
  ipam_pool_id                          = data.aws_vpc_ipam_pool.current.id
  name                                  = var.name
  private_subnet_netmask                = var.private_subnet_netmask
  pulic_subnet_netmask                  = var.public_subnet_netmask
  tags                                  = var.tags
  transit_gateway_id                    = data.aws_ec2_transit_gateway.this.id
  vpc_cidr                              = var.vpc_cidr

  transit_gateway_rotues = {
    private = aws_ec2_managed_prefix_list.internal.id
  }
}
```

### Enabling NAT Gateways

To enable NAT gateways in your VPC, you can use the `enable_nat_gateway` and `nat_gateway_mode` variables. Here are some examples:

```hcl
# Single NAT Gateway for all AZs
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_nat_gateway = true
  nat_gateway_mode   = "single"
  # ... other configuration ...
}

# One NAT Gateway per AZ for high availability
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_nat_gateway = true
  nat_gateway_mode   = "one_per_az"
  # ... other configuration ...
}
```

Remember that NAT gateways incur costs, so choose the configuration that best balances your availability requirements and budget.

### Using Transit Gateway

The module supports connecting your VPC to an AWS Transit Gateway. Here are some common configurations:

```hcl
# Basic Transit Gateway connection
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_transit_gateway = true
  transit_gateway_id     = "tgw-1234567890abcdef0" # Your Transit Gateway ID
  
  # Default route to Transit Gateway for private subnets
  transit_gateway_routes = {
    private = "10.0.0.0/8"  # Route all 10.0.0.0/8 traffic to Transit Gateway
  }
  # ... other configuration ...
}

# Transit Gateway with appliance mode (for network appliances)
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_transit_gateway                = true
  enable_transit_gateway_appliance_mode = true
  transit_gateway_id                    = "tgw-1234567890abcdef0"
  
  # Using a prefix list for routes
  transit_gateway_routes = {
    private = "pl-1234567890abcdef0"  # AWS prefix list ID
  }
  # ... other configuration ...
}
```

The Transit Gateway configuration supports:

- Connecting to an existing Transit Gateway
- Appliance mode for network appliance deployments
- Custom routing using CIDR blocks or prefix lists
- Optional NAT Gateway access for Transit Gateway subnets

### Using Private Endpoints

The module supports creating VPC endpoints for AWS services. Here are some common configurations:

```hcl
# Enable SSM endpoints (Session Manager)
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_ssm = true
  # ... other configuration ...
}

# Enable specific private endpoints
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_private_endpoints = [
    "ecr.api",
    "ecr.dkr",
    "s3",
    "logs"
  ]
  # ... other configuration ...
}
```

You can use `enable_ssm` as a shortcut to enable the SSM endpoints.

```hcl
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_ssm = true
}
```

## Using Route53 Resolver Rules

The module supports automatically associating shared Route53 Resolver Rules with your VPC. By default, any resolver rules shared with your account will be automatically associated. Here are some configuration examples:

```hcl
# Disable automatic resolver rule association
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_route53_resolver_rules = false
  # ... other configuration ...
}

# Exclude specific resolver rules from association
module "vpc" {
  source  = "appvia/network/aws"
  version = "0.0.8"
  
  enable_route53_resolver_rules    = true
  exclude_route53_resolver_rules   = ["rslvr-rr-1234567890abcdef0"]  # Resolver Rule IDs to exclude
  # ... other configuration ...
}
```

By default (`enable_route53_resolver_rules = true`), the module will:

- Automatically discover all resolver rules shared with your account
- Associate them with the VPC being created
- Allow you to exclude specific rules using the `exclude_route53_resolver_rules` variable

## Adding Additional Subnets

To add more subnets to your VPC, you can extend the subnet configurations in your Terraform code. Here are some examples:

### Adding Public Subnets

```hcl
module "vpc" { 
  additional_subnets = {
    public = {
      cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
      tags = {
        Name = "public-subnets"
      }
    }
  }
}
```

Remember to:

1. Ensure CIDR blocks don't overlap
2. Consider your IP address space requirements
3. Follow your organization's IP addressing scheme
4. Update route tables and network ACLs accordingly

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (<https://terraform-docs.io/user-guide/installation/>)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Is the name of the network to provision | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Additional subnets to create in the network | `map(any)` | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zone the network should be deployed into | `number` | `2` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Indicates the transit gateway default route table should be associated with the subnets | `bool` | `true` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Indicates the transit gateway default route table should be propagated to the subnets | `bool` | `true` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Indicates the cidr block for the network should be assigned from IPAM | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_private_endpoints"></a> [enable\_private\_endpoints](#input\_enable\_private\_endpoints) | Indicates the network should provision private endpoints | `list(string)` | `[]` | no |
| <a name="input_enable_route53_resolver_rules"></a> [enable\_route53\_resolver\_rules](#input\_enable\_route53\_resolver\_rules) | Automatically associates any shared route53 resolver rules with the VPC | `bool` | `true` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | Indicates we should provision SSM private endpoints | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_appliance_mode"></a> [enable\_transit\_gateway\_appliance\_mode](#input\_enable\_transit\_gateway\_appliance\_mode) | Indicates the network should be connected to a transit gateway in appliance mode | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_subnet_natgw"></a> [enable\_transit\_gateway\_subnet\_natgw](#input\_enable\_transit\_gateway\_subnet\_natgw) | Indicates if the transit gateway subnets should be connected to a nat gateway | `bool` | `false` | no |
| <a name="input_exclude_route53_resolver_rules"></a> [exclude\_route53\_resolver\_rules](#input\_exclude\_route53\_resolver\_rules) | List of resolver rules to exclude from association | `list(string)` | `[]` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | An optional pool id to use for IPAM pool to use | `string` | `null` | no |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | The configuration mode of the NAT gateways | `string` | `"none"` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | `0` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Additional tags for the private subnets | `map(string)` | `{}` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `0` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Additional tags for the public subnets | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | If enabled, and not lookup is disabled, the transit gateway id to connect to | `string` | `null` | no |
| <a name="input_transit_gateway_routes"></a> [transit\_gateway\_routes](#input\_transit\_gateway\_routes) | If enabled, this is the cidr block to route down the transit gateway | `map(string)` | <pre>{<br/>  "private": "10.0.0.0/8"<br/>}</pre> | no |
| <a name="input_transit_subnet_tags"></a> [transit\_subnet\_tags](#input\_transit\_subnet\_tags) | Additional tags for the transit subnets | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | An optional cidr block to assign to the VPC (if not using IPAM) | `string` | `null` | no |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | The name of the VPC to create | `string` | `"default"` | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | An optional range assigned to the VPC | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | The public IPs of the NAT Gateways i.e [public\_ip, public\_ip] |
| <a name="output_natgw_id_per_az"></a> [natgw\_id\_per\_az](#output\_natgw\_id\_per\_az) | The IDs of the NAT Gateways (see aws-ia/vpc/aws for details) |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private route tables ie. [route\_table\_id, route\_table\_id] |
| <a name="output_private_subnet_attributes_by_az"></a> [private\_subnet\_attributes\_by\_az](#output\_private\_subnet\_attributes\_by\_az) | The attributes of the private subnets (see aws-ia/vpc/aws for details) |
| <a name="output_private_subnet_cidr_by_id"></a> [private\_subnet\_cidr\_by\_id](#output\_private\_subnet\_cidr\_by\_id) | A map of the private subnet ID to CIDR block i.e. us-west-2a => subnet\_cidr |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | A list of the CIDRs for the private subnets |
| <a name="output_private_subnet_id_by_az"></a> [private\_subnet\_id\_by\_az](#output\_private\_subnet\_id\_by\_az) | A map of availability zone to subnet id of the private subnets i.e. eu-west-2a => subnet\_id |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets i.e. [subnet\_id, subnet\_id] |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | The IDs of the public route tables ie. [route\_table\_id, route\_table\_id] |
| <a name="output_public_subnet_attributes_by_az"></a> [public\_subnet\_attributes\_by\_az](#output\_public\_subnet\_attributes\_by\_az) | The attributes of the public subnets (see aws-ia/vpc/aws for details) |
| <a name="output_public_subnet_cidr_by_id"></a> [public\_subnet\_cidr\_by\_id](#output\_public\_subnet\_cidr\_by\_id) | A map of the public subnet ID to CIDR block i.e. us-west-2a => subnet\_cidr |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | A list of the CIDRs for the public subnets i.e. [subnet\_cidr, subnet\_cidr] |
| <a name="output_public_subnet_id_by_az"></a> [public\_subnet\_id\_by\_az](#output\_public\_subnet\_id\_by\_az) | A map of availability zone to subnet id of the public subnets i.e. eu-west-2a => subnet\_id |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the public subnets i.e. [subnet\_id, subnet\_id] |
| <a name="output_rt_attributes_by_type_by_az"></a> [rt\_attributes\_by\_type\_by\_az](#output\_rt\_attributes\_by\_type\_by\_az) | The attributes of the route tables (see aws-ia/vpc/aws for details) |
| <a name="output_transit_gateway_attachment_id"></a> [transit\_gateway\_attachment\_id](#output\_transit\_gateway\_attachment\_id) | The ID of the transit gateway attachment if enabled |
| <a name="output_transit_route_table_by_az"></a> [transit\_route\_table\_by\_az](#output\_transit\_route\_table\_by\_az) | A map of availability zone to transit gateway route table ID i.e eu-west-2a => route\_table\_id |
| <a name="output_transit_route_table_ids"></a> [transit\_route\_table\_ids](#output\_transit\_route\_table\_ids) | The IDs of the transit gateway route tables ie. [route\_table\_id, route\_table\_id] |
| <a name="output_transit_subnet_attributes_by_az"></a> [transit\_subnet\_attributes\_by\_az](#output\_transit\_subnet\_attributes\_by\_az) | The attributes of the transit gateway subnets (see aws-ia/vpc/aws for details) |
| <a name="output_transit_subnet_ids"></a> [transit\_subnet\_ids](#output\_transit\_subnet\_ids) | The IDs of the transit gateway subnets ie. [subnet\_id, subnet\_id] |
| <a name="output_vpc_attributes"></a> [vpc\_attributes](#output\_vpc\_attributes) | The attributes of the VPC (see aws-ia/vpc/aws for details) |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
