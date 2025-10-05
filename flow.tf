locals {
  ## Whether to provision the vpc flow logs
  enable_flow_logs = var.flow_logs != null
  ## The additional tags to apply to the flow logs
  flow_logs_tags = merge(var.tags, {
    "flow-log-type" = try(var.flow_logs.destination_type, "none")
    "flow-log"      = "true",
    "vpc"           = var.name,
    "vpc-id"        = module.vpc.vpc_attributes.id
  })
}


## Provision the vpc flow logs if required 
resource "aws_flow_log" "current" {
  count = local.enable_flow_logs ? 1 : 0

  log_destination_type = var.flow_logs.destination_type
  log_destination      = var.flow_logs.destination_arn
  log_format           = var.flow_logs.log_format
  traffic_type         = var.flow_logs.traffic_type
  tags                 = local.flow_logs_tags
  vpc_id               = module.vpc.vpc_attributes.id

  dynamic "destination_options" {
    for_each = var.flow_logs.destination_type == "s3" ? [true] : []

    content {
      file_format                = var.flow_logs.file_format
      hive_compatible_partitions = var.flow_logs.hive_compatible_partitions
      per_hour_partition         = var.flow_logs.per_hour_partition
    }
  }
}
