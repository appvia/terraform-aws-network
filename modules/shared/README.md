<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name used to prefix resources, and which should be unique | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the NACL | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to provision the subnets in | `string` | n/a | yes |
| <a name="input_permitted_subnets"></a> [permitted\_subnets](#input\_permitted\_subnets) | A collection of additional subnets to allow access to | `list(string)` | `[]` | no |
| <a name="input_ram_share_prefix"></a> [ram\_share\_prefix](#input\_ram\_share\_prefix) | The prefix to use for the RAM share name | `string` | `"network-share-"` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | A collection of routes to add to the subnets | <pre>list(object({<br/>    cidr = string<br/>    ## The cidr block to provision the subnets (optional)<br/>    carrier_gateway_id = optional(string, null)<br/>    ## Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone.<br/>    core_network_arn = optional(string, null)<br/>    ## The Amazon Resource Name (ARN) of a core network.<br/>    egress_only_gateway_id = optional(string, null)<br/>    ## Identifier of a VPC Egress Only Internet Gateway.<br/>    gateway_id = optional(string, null)<br/>    ## Identifier of a VPC internet gateway or a virtual private gateway. Specify local when updating a previously imported local route.<br/>    nat_gateway_id = optional(string, null)<br/>    ## Identifier of a VPC NAT gateway.<br/>    local_gateway_id = optional(string, null)<br/>    ## Identifier of a Outpost local gateway.<br/>    network_interface_id = optional(string, null)<br/>    ## Identifier of an EC2 network interface.<br/>    transit_gateway_id = optional(string, null)<br/>    ## Identifier of an EC2 Transit Gateway.<br/>    vpc_endpoint_id = optional(string, null)<br/>    ## Identifier of a VPC Endpoint.<br/>    vpc_peering_connection_id = optional(string, null)<br/>    ## Identifier of a VPC peering connection.<br/>  }))</pre> | `[]` | no |
| <a name="input_share"></a> [share](#input\_share) | The principals to share the provisioned subnets with | <pre>object({<br/>    accounts = optional(list(string), [])<br/>    ## A list of accounts to share the subnets with<br/>    organizational_units = optional(list(string), [])<br/>    ## A list of organizational units to share the subnets with<br/>  })</pre> | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A collectionn of subnets to provision for the tenant | <pre>map(object({<br/>    cidrs = list(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_inbound_network_acls"></a> [inbound\_network\_acls](#output\_inbound\_network\_acls) | The inbound network ACLs provisioned |
| <a name="output_outbound_network_acls"></a> [outbound\_network\_acls](#output\_outbound\_network\_acls) | The outbound network ACLs provisioned |
| <a name="output_route_table"></a> [route\_table](#output\_route\_table) | The route table provisioned |
| <a name="output_route_table_arn"></a> [route\_table\_arn](#output\_route\_table\_arn) | The route table arn |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | A list of all the subnet ids |
| <a name="output_subnet_ids_by_name"></a> [subnet\_ids\_by\_name](#output\_subnet\_ids\_by\_name) | A map of the subnets ids by the name |
| <a name="output_subnets_map"></a> [subnets\_map](#output\_subnets\_map) | A map of the subnets |
<!-- END_TF_DOCS -->