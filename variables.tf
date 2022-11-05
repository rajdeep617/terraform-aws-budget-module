variable "budgets" {
  description = "Budget type properties"
  type = map(object({
    budget_type = string
    limit_amount = number
    limit_unit = string
    time_unit = string
    notification_threshold = number
    threshold_type = string
  }))
}

variable "time_period_start" {
  description = "Budget start date"
  type = string
}

variable "time_period_end" {
  description = "Budget end date"
  type    = string
  default = null
}

variable "notification" {
  description = "Budget notification properties"
  type = object({
    comparison_operator        = string
    notification_type          = string
    subscriber_email_addresses = set(any)
    subscriber_sns_topic_arns  = set(any)
  })
}