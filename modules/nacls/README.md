<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the subnets to create the NACL for | `string` | n/a | yes |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | The number of subnets to create the NACL for | `number` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The subnet IDs to apply the NACL to | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the NACL | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to create the NACL in | `string` | n/a | yes |
| <a name="input_inbound"></a> [inbound](#input\_inbound) | The inbound rules to apply to the NACL | <pre>list(object({<br/>    cidr_block      = string<br/>    from_port       = optional(number, null)<br/>    icmp_code       = optional(number, 0)<br/>    icmp_type       = optional(number, 0)<br/>    ipv6_cidr_block = optional(string, null)<br/>    protocol        = optional(number, -1)<br/>    rule_action     = optional(string, "allow")<br/>    rule_number     = number<br/>    to_port         = optional(number, null)<br/>  }))</pre> | `[]` | no |
| <a name="input_outbound"></a> [outbound](#input\_outbound) | The outbound rules to apply to the NACL | <pre>list(object({<br/>    cidr_block      = string<br/>    from_port       = optional(number, null)<br/>    icmp_code       = optional(number, 0)<br/>    icmp_type       = optional(number, 0)<br/>    ipv6_cidr_block = optional(string, null)<br/>    protocol        = optional(number, -1)<br/>    rule_action     = optional(string, "allow")<br/>    rule_number     = number<br/>    to_port         = optional(number, null)<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->