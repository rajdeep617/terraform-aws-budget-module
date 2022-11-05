output "aws_budget_ids" {
  value = {
    for k,v in aws_budgets_budget.main : k => v.id
  }
}

output "aws_buget_arns" {
  value = {
    for k,v in aws_budgets_budget.main : k => v.arn
  }
}