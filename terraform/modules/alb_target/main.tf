terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Target group for Lambda
resource "aws_lb_target_group" "lambda" {
  name        = "lambda-target"
  target_type = "lambda"
}

# Attach Lambda to target group
resource "aws_lb_target_group_attachment" "lambda" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = var.function_arn
  depends_on       = [aws_lambda_permission.alb]
}

# Allow ALB to invoke Lambda
resource "aws_lambda_permission" "alb" {
  statement_id  = "AllowALBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda.arn
}

# Listener rule to forward to Lambda
resource "aws_lb_listener_rule" "lambda" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}