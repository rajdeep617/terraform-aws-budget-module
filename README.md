# terraform-aws-budget-mudule
This module will help you to setup AWS Budget in your account to control cost. This module is very flexible and you can create:
* Cost Budget on account
* Cost budget on Specific service
* Usages budget on Service
* Notification

## Usage
```hcl
module "aws_budget" {
  source            = "git::https://github.com/rajdeep617/terraform-aws-budget-module.git"
  budgets           = var.budgets
  time_period_start = var.time_period_start
  notification      = var.notification
}

variable "time_period_start" {
  description = "Budget start date"
  type        = string
  default     = "2022-10-01_12:00"
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
    AWS = {
      budget_type            = "COST"
      limit_amount           = 2400
      limit_unit             = "USD"
      time_unit              = "MONTHLY"
      notification_threshold = 80
      threshold_type         = "PERCENTAGE" #PERCENTAGE OR ABSOLUTE_VALUE 
    }
  }
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
    comparison_operator        = "GREATER_THAN"            #LESS_THAN, EQUAL_TO, OR GREATER_THAN
    notification_type          = "FORECASTED"              #ACTUAL or FORECASTED
    subscriber_email_addresses = ["example@example.com"]   #EMAIL ID
    subscriber_sns_topic_arns  = ["example_sns_arn"]       #SNS TOPIC ARN
  } 
}
```

## Examples
Refer to the [examples](https://github.com/rajdeep617/terraform-aws-budget-module/tree/master/examples) directory in this GitHub repository for complete terraform code example.

## Known issues

No known issues.

## Requirements

| Name | Version  |
|------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29  |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0  |

## Modules

No modules.

## Resources
| Name                                                                                                                              | Type     |
|-----------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_budgets_budget.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget)             | resource |

## Inputs
| Name                                                                                         | Description                     | Type                                                                                                                                                                                                                                                        | Default | Required |
|----------------------------------------------------------------------------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|:--------:|
| <a name="input_budgets"></a> [budgets](#input\_budgets)                                      | Budget type properties          | <pre>map(object({<br>  budget_type            = string<br>  limit_amount           = number<br>  limit_unit             = string<br>  time_unit              = string<br>  notification_threshold = number<br>  threshold_type         = string<br>})</pre> |         |   Yes    |
| <a name="input_time_period_start"></a> [time\_period\_start](#input\_time\_period\_start)    | Budget start date               | `string`                                                                                                                                                                                                                                                    |         |   Yes    |
| <a name="input_time_period_end"></a> [global\_time\_period\_end](#input\_time\_period\_end)  | Budget end date                 | `string`                                                                                                                                                                                                                                                    | null    |    No    |
| <a name="input_notification"></a> [notification](#input\_notification)                       | Budget notification properties  | <pre>object({<br>  comparison_operator       = string<br>  notification_type         = string<br>  subscriber_email_addresse = set(any)<br>  subscriber_sns_topic_arns = set(any)<br>})</pre>                                                               |         |   Yes    |

## Outputs

| Name                                                                               | Description     |
|------------------------------------------------------------------------------------|-----------------|
| <a name="output_aws_budget_ids"></a> [aws\_budget\_ids](#output\_aws\_budget\_ids) | AWS Budget IDs  |
| <a name="output_aws_buget_arns"></a> [aws\_buget\_arns](#output\_aws\_buget\_arns) | AWS Budget ARNs |

## Authors
Module managed by [Rajdeep Hayer](https://github.com/rajdeep617).