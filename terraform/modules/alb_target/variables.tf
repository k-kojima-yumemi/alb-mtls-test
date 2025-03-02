variable "function_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
}

variable "priority" {
  description = "Priority for the listener rule"
  type        = number
  default     = 100
}

variable "path_pattern" {
  description = "Path pattern to match for the listener rule"
  type        = string
  default     = "/*"
}