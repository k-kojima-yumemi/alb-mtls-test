variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "subnet_names" {
  description = "List of subnet names for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
}
