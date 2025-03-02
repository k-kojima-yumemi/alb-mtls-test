output "target_group_arn" {
  description = "ARN of the Lambda target group"
  value       = aws_lb_target_group.lambda.arn
}

output "listener_rule_arn" {
  description = "ARN of the listener rule"
  value       = aws_lb_listener_rule.lambda.arn
}

output "target_group_name" {
  description = "Name of the Lambda target group"
  value       = aws_lb_target_group.lambda.name
}