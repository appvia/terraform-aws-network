<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Is the name of the network to provision | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A collection of subnets to provison, and rules to distribute to accounts | <pre>map(object({<br/>    availability_zones = optional(number, null)<br/>    # The availability zones to deploy the subnet into, else default to vpc availability zones<br/>    netmask = optional(number, null)<br/>    # The netmask for the subnet each of the subnets against the availability zones<br/>    tags = optional(map(string), null)<br/>    # Additional tags for the subnets<br/>    shared = optional(object({<br/>      accounts = optional(list(string), null)<br/>      # A list of accounts to share the subnets with<br/>      organization_units = optional(list(string), null)<br/>      # A list of organization units to share the subnets with<br/>    }), null)<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | n/a | yes |
| <a name="input_associated_resolver_rules"></a> [associated\_resolver\_rules](#input\_associated\_resolver\_rules) | A list of resolver rules to associate with the VPC | `list(string)` | `[]` | no |
| <a name="input_associated_route53_zones"></a> [associated\_route53\_zones](#input\_associated\_route53\_zones) | A list of route53 zones to associate with the VPC | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zone the network should be deployed into | `number` | `2` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Indicates the transit gateway default route table should be associated with the subnets | `bool` | `true` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Indicates the transit gateway default route table should be propagated to the subnets | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_private_endpoints"></a> [enable\_private\_endpoints](#input\_enable\_private\_endpoints) | Indicates the network should provision private endpoints | `list(string)` | `[]` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | Indicates we should provision SSM private endpoints | `bool` | `false` | no |
| <a name="input_enable_transit_gateway"></a> [enable\_transit\_gateway](#input\_enable\_transit\_gateway) | Indicates the network should provison nat gateways | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_appliance_mode"></a> [enable\_transit\_gateway\_appliance\_mode](#input\_enable\_transit\_gateway\_appliance\_mode) | Indicates the network should be connected to a transit gateway in appliance mode | `bool` | `false` | no |
| <a name="input_enable_transit_gateway_subnet_natgw"></a> [enable\_transit\_gateway\_subnet\_natgw](#input\_enable\_transit\_gateway\_subnet\_natgw) | Indicates if the transit gateway subnets should be connected to a nat gateway | `bool` | `false` | no |
| <a name="input_ipam_pool_id"></a> [ipam\_pool\_id](#input\_ipam\_pool\_id) | An optional pool id to use for IPAM pool to use | `string` | `null` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | If enabled, and not lookup is disabled, the transit gateway id to connect to | `string` | `""` | no |
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
| <a name="output_private_subnet_cidr_by_id"></a> [private\_subnet\_cidr\_by\_id](#output\_private\_subnet\_cidr\_by\_id) | A map of subnet id to CIDR block of the private subnets i.e. subnet\_id => cidr\_block |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | A list of the CIDRs for the private subnets |
| <a name="output_private_subnet_id_by_az"></a> [private\_subnet\_id\_by\_az](#output\_private\_subnet\_id\_by\_az) | A map of availability zone to subnet id of the private subnets i.e. eu-west-2a => subnet\_id |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets i.e. [subnet\_id, subnet\_id] |
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