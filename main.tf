locals {
  #At present AWS only support following service filter
  service_filter = {
    ec2         = "Amazon Elastic Compute Cloud"
    redshift    = "Amazon Redshift"
    rds         = "Amazon Relational Database Service"
    elasticache = "Amazon ElastiCache"
    opensearch  = "Amazon OpenSearch Service"
  }

  cost_types = {
    # A boolean value whether to include credits in the cost budget.
    include_credit = true

    # Specifies whether a budget includes discounts.
    include_discount = true

    # A boolean value whether to include other subscription costs in the cost budget.
    include_other_subscription = true

    # A boolean value whether to include recurring costs in the cost budget.
    include_recurring = true

    # A boolean value whether to include refunds in the cost budget.
    include_refund = true

    # A boolean value whether to include subscriptions in the cost budget.
    include_subscription = true

    # A boolean value whether to include support costs in the cost budget.
    include_support = true

    # A boolean value whether to include support costs in the cost budget.
    include_tax = true

    # A boolean value whether to include support costs in the cost budget.
    include_upfront = true

    # Specifies whether a budget uses the amortized rate.
    use_amortized = false

    # A boolean value whether to use blended costs in the cost budget.
    use_blended = false
  }

}

resource "aws_budgets_budget" "main" {
  for_each          = var.budgets
  name              = "${each.key}-${each.value.time_unit}-${each.value.budget_type}-BUDGET"
  budget_type       = each.value.budget_type
  limit_amount      = each.value.limit_amount
  limit_unit        = each.value.limit_unit
  time_unit         = each.value.time_unit
  time_period_start = var.time_period_start
  time_period_end   = var.time_period_end

  cost_types {
    include_credit             = lookup(local.cost_types, "include_credit")
    include_discount           = lookup(local.cost_types, "include_discount")
    include_other_subscription = lookup(local.cost_types, "include_other_subscription")
    include_recurring          = lookup(local.cost_types, "include_recurring")
    include_refund             = lookup(local.cost_types, "include_refund")
    include_subscription       = lookup(local.cost_types, "include_subscription")
    include_support            = each.key != "AWS" ? false : lookup(local.cost_types, "include_support")
    include_tax                = lookup(local.cost_types, "include_tax")
    include_upfront            = lookup(local.cost_types, "include_upfront")
    use_amortized              = lookup(local.cost_types, "use_amortized")
    use_blended                = lookup(local.cost_types, "use_blended")
  }

  dynamic "cost_filter" {
    for_each = contains(keys(local.service_filter), lower(each.key)) == true ? ["1"] : []
    content {
      name   = "Service"
      values = [lookup(local.service_filter, lower(each.key))]
    }
  }

  notification {
    comparison_operator        = var.notification.comparison_operator
    threshold                  = each.value.notification_threshold
    threshold_type             = each.value.threshold_type
    notification_type          = var.notification.notification_type
    subscriber_sns_topic_arns  = var.notification.subscriber_sns_topic_arns
    subscriber_email_addresses = var.notification.subscriber_email_addresses
  }

}

