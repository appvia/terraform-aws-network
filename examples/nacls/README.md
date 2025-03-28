<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Inputs

No inputs.

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