locals {
  inbound = merge([
    for idx in range(var.subnet_count) : {
      for rule_idx, rule in try(var.inbound_rules, []) :
      "${idx}-${rule_idx}" => {
        id   = var.subnet_ids[idx]
        rule = rule
      }
    }
  ]...)

  outbound = merge([
    for idx in range(var.subnet_count) : {
      for rule_idx, rule in try(var.outbound_rules, []) :
      "${idx}-${rule_idx}" => {
        id   = var.subnet_ids[idx]
        rule = rule
      }
    }
  ]...)
}
