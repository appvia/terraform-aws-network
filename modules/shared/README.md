<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name used to prefix resources, and which should be unique | `string` | n/a | yes |
| <a name="input_share"></a> [share](#input\_share) | The principals to share the provisioned subnets with | <pre>object({<br/>    accounts = optional(list(string), [])<br/>    ## A list of accounts to share the subnets with<br/>    organizational_units = optional(list(string), [])<br/>    ## A list of organizational units to share the subnets with<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the NACL | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to provision the subnets in | `string` | n/a | yes |
| <a name="input_permitted_subnets"></a> [permitted\_subnets](#input\_permitted\_subnets) | A collection of additional subnets to allow access to | `list(string)` | `[]` | no |
| <a name="input_ram_share_prefix"></a> [ram\_share\_prefix](#input\_ram\_share\_prefix) | The prefix to use for the RAM share name | `string` | `"network-share-"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A collectionn of subnets to provision for the tenant | <pre>map(object({<br/>    cidrs = list(string)<br/>    ## The cidr block to provision the subnets (optional)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_inbound_network_acls"></a> [inbound\_network\_acls](#output\_inbound\_network\_acls) | The inbound network ACLs provisioned |
| <a name="output_outbound_network_acls"></a> [outbound\_network\_acls](#output\_outbound\_network\_acls) | The outbound network ACLs provisioned |
<!-- END_TF_DOCS -->