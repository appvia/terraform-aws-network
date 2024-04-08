![Github Actions](../../workflows/terraform/badge.svg)

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

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_links"></a> [private\_links](#module\_private\_links) | terraform-aws-modules/security-group/aws | 5.1.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | aws-ia/vpc/aws | = 4.4.2 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_resolver_rule_association.vpc_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_vpc_endpoint.vpe_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_resolver_rules.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_rules) | data source |
| [aws_vpc_ipam_pool.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Is the name of the network to provision | `string` | n/a | yes |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Additional subnets to create in the network | `map(any)` | `null` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zone the network should be deployed into | `number` | `2` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Indicates the cidr block for the network should be assigned from IPAM | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_private_endpoints"></a> [enable\_private\_endpoints](#input\_enable\_private\_endpoints) | Indicates the network should provision private endpoints | `list(string)` | `[]` | no |
| <a name="input_enable_route53_resolver_rules"></a> [enable\_route53\_resolver\_rules](#input\_enable\_route53\_resolver\_rules) | Automatically associates any shared route53 resolver rules with the VPC | `bool` | `true` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | Indicates we should provision SSM private endpoints | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_appliance_mode"></a> [enable\_transit\_gateway\_appliance\_mode](#input\_enable\_transit\_gateway\_appliance\_mode) | Indicates the network should be connected to a transit gateway in appliance mode | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_subnet_natgw"></a> [enable\_transit\_gateway\_subnet\_natgw](#input\_enable\_transit\_gateway\_subnet\_natgw) | Indicates if the transit gateway subnets should be connected to a nat gateway | `bool` | `false` | no |
| <a name="input_exclude_resolver_rules"></a> [exclude\_resolver\_rules](#input\_exclude\_resolver\_rules) | List of resolver rules to exclude from association | `list(string)` | `[]` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | An optional pool id to use for IPAM pool to use | `string` | `""` | no |
| <a name="input_ipam_pool_name"></a> [ipam\_pool\_name](#input\_ipam\_pool\_name) | An optional pool name to use for IPAM pool to use | `string` | `""` | no |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | The configuration mode of the NAT gateways | `string` | `"none"` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `0` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | If enabled, and not lookup is disabled, the transit gateway id to connect to | `string` | `""` | no |
| <a name="input_transit_gateway_routes"></a> [transit\_gateway\_routes](#input\_transit\_gateway\_routes) | If enabled, this is the cidr block to route down the transit gateway | `map(string)` | <pre>{<br>  "private": "10.0.0.0/8"<br>}</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | An optional cidr block to assign to the VPC (if not using IPAM) | `string` | `null` | no |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | The name of the VPC to create | `string` | `"default"` | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | An optional range assigned to the VPC | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | The public IPs of the NAT Gateways |
| <a name="output_natgw_id_per_az"></a> [natgw\_id\_per\_az](#output\_natgw\_id\_per\_az) | The IDs of the NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private route tables |
| <a name="output_private_subnet_attributes_by_az"></a> [private\_subnet\_attributes\_by\_az](#output\_private\_subnet\_attributes\_by\_az) | The attributes of the private subnets |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | A map of the CIDRs for the private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets |
| <a name="output_private_subnet_list"></a> [private\_subnet\_list](#output\_private\_subnet\_list) | A list of the CIDRs for the private subnets |
| <a name="output_private_subnet_netmask"></a> [private\_subnet\_netmask](#output\_private\_subnet\_netmask) | The netmask for the private subnets |
| <a name="output_public_subnet_attributes_by_az"></a> [public\_subnet\_attributes\_by\_az](#output\_public\_subnet\_attributes\_by\_az) | The attributes of the public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the public subnets |
| <a name="output_public_subnet_list"></a> [public\_subnet\_list](#output\_public\_subnet\_list) | A list of the CIDRs for the public subnets |
| <a name="output_public_subnet_netmask"></a> [public\_subnet\_netmask](#output\_public\_subnet\_netmask) | The netmask for the public subnets |
| <a name="output_rt_attributes_by_type_by_az"></a> [rt\_attributes\_by\_type\_by\_az](#output\_rt\_attributes\_by\_type\_by\_az) | The attributes of the route tables |
| <a name="output_transit_gateway_attachment_id"></a> [transit\_gateway\_attachment\_id](#output\_transit\_gateway\_attachment\_id) | The ID of the transit gateway attachment |
| <a name="output_transit_subnet_attributes_by_az"></a> [transit\_subnet\_attributes\_by\_az](#output\_transit\_subnet\_attributes\_by\_az) | The attributes of the transit gateway subnets |
| <a name="output_transit_subnet_ids"></a> [transit\_subnet\_ids](#output\_transit\_subnet\_ids) | The IDs of the transit gateway subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
