terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

# IAM role for Lambda
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

# Lambda function code
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/index.mjs"
  output_path = "${path.module}/lambda_handler.zip"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

# Lambda function
resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda.output_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs22.x"
  architectures    = ["arm64"]
  memory_size      = 128
  timeout          = 3
  package_type     = "Zip"

  logging_config {
    log_group  = aws_cloudwatch_log_group.lambda.id
    log_format = "JSON"
  }

  lifecycle {
    ignore_changes = [
      // source_code_hash,
    ]
  }
}
