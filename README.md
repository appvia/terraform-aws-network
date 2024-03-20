<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | aws-ia/vpc/aws | = 4.4.2 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_ipam_pool.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_ipam_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zone the network should be deployed into | `number` | `2` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Indicates the cidr block for the network should be assigned from IPAM | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_appliance_mode"></a> [enable\_transit\_gateway\_appliance\_mode](#input\_enable\_transit\_gateway\_appliance\_mode) | Indicates the network should be connected to a transit gateway in appliance mode | `bool` | `false` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | An optional pool id to use for IPAM pool to use | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Is the name of the network to provision | `string` | n/a | yes |
| <a name="input_nat_gateway_mode"></a> [nat\_gateway\_mode](#input\_nat\_gateway\_mode) | The configuration mode of the NAT gateways | `string` | `"none"` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | n/a | yes |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | If enabled, and not lookup is disabled, the transit gateway id to connect to | `string` | `""` | no |
| <a name="input_transit_gateway_routes"></a> [transit\_gateway\_routes](#input\_transit\_gateway\_routes) | If enabled, this is the cidr block to route down the transit gateway | `map(string)` | <pre>{<br>  "private": "10.0.0.0/8"<br>}</pre> | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | An optional range assigned to the VPC | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | The public IPs of the NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private route tables |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets |
| <a name="output_private_subnet_netmask"></a> [private\_subnet\_netmask](#output\_private\_subnet\_netmask) | The netmask for the private subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the public subnets |
| <a name="output_public_subnet_netmask"></a> [public\_subnet\_netmask](#output\_public\_subnet\_netmask) | The netmask for the public subnets |
| <a name="output_transit_gateway_attachment_id"></a> [transit\_gateway\_attachment\_id](#output\_transit\_gateway\_attachment\_id) | The ID of the transit gateway attachment |
| <a name="output_transit_subnet_ids"></a> [transit\_subnet\_ids](#output\_transit\_subnet\_ids) | The IDs of the transit gateway subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->