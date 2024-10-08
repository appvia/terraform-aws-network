<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zone the network should be deployed into | `number` | `2` | no |
| <a name="input_enable_ipam"></a> [enable\_ipam](#input\_enable\_ipam) | Indicates the cidr block for the network should be assigned from IPAM | `bool` | `false` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | Indicates we should provision SSM private endpoints | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Indicates the network should provison nat gateways | `bool` | `true` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | The id of the IPAM pool to use for the network | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Is the name of the network to provision | `string` | `"test-vpc"` | no |
| <a name="input_private_subnet_netmask"></a> [private\_subnet\_netmask](#input\_private\_subnet\_netmask) | The netmask for the private subnets | `number` | `24` | no |
| <a name="input_public_subnet_netmask"></a> [public\_subnet\_netmask](#input\_public\_subnet\_netmask) | The netmask for the public subnets | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "test",<br/>  "GitRepo": "https://github.com/appvia/terraform-aws-network",<br/>  "Terraform": "true"<br/>}</pre> | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | If enabled, and not lookup is disabled, the transit gateway id to connect to | `string` | `"tgw-04ad8f026be8b7eb6"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | An optional cidr block to assign to the VPC (if not using IPAM) | `string` | `"10.88.0.0/21"` | no |
| <a name="input_vpc_netmask"></a> [vpc\_netmask](#input\_vpc\_netmask) | The netmask for the VPC when using IPAM | `number` | `null` | no |

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