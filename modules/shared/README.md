<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A name to associate with the resources | `string` | n/a | yes |
| <a name="input_subnet_arns"></a> [subnet\_arns](#input\_subnet\_arns) | A collection of subnets to share with one or more principals | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A collection of tags to apply to the resources | `map(string)` | n/a | yes |
| <a name="input_ram_share_prefix"></a> [ram\_share\_prefix](#input\_ram\_share\_prefix) | The prefix to use for the RAM share name | `string` | `"network-share-"` | no |
| <a name="input_share"></a> [share](#input\_share) | The principals to share the subnets with | <pre>object({<br/>    accounts = optional(list(string), [])<br/>    # A list of accounts to share the subnets with<br/>    organizational_units = optional(list(string), [])<br/>    # A list of organization units to share the subnets with<br/>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->