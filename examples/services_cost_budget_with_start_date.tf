terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "budgets" {
  description = "Budget type properties"
  type = map(object({
    budget_type            = string
    limit_amount           = number
    limit_unit             = string
    time_unit              = string
    notification_threshold = number
    threshold_type         = string
  }))
  default = {
    EC2 = {
      budget_type            = "COST"
      limit_amount           = 1200
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE
    }
    OPENSEARCH = {
      budget_type            = "COST"
      limit_amount           = 1200
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE
    }
    ELASTICACHE = {
      budget_type            = "COST"
      limit_amount           = 1200
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE
    }
    RDS = {
      budget_type            = "COST"
      limit_amount           = 1200
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE
    }
    REDSHIFT = {
      budget_type            = "COST"
      limit_amount           = 1200
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE
    }
  }
}

variable "time_period_start" {
  description = "Budget start date"
  type        = string
  default     = "2022-10-01_12:00"
}

variable "notification" {
  description = "Budget notification properties"
  type = object({
    comparison_operator        = string
    notification_type          = string
    subscriber_email_addresses = set(any)
    subscriber_sns_topic_arns  = set(any)
  })
  default = {
    comparison_operator        = "GREATER_THAN"          #LESS_THAN, EQUAL_TO, OR GREATER_THAN
    notification_type          = "FORECASTED"            #ACTUAL or FORECASTED
    subscriber_email_addresses = ["example@example.com"] #EMAIL ID
    subscriber_sns_topic_arns  = []     #SNS TOPIC ARN
  }
}

module "aws_budget" {
  source            = "../"
  budgets           = var.budgets
  time_period_start = var.time_period_start
  notification      = var.notification
}

output "aws_budget_ids" {
  value = module.aws_budget.aws_budget_ids
}

output "aws_buget_arns" {
  value = module.aws_budget.aws_buget_arns
}