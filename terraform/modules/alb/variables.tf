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

variable "trust_store_arn" {
  description = "ARN of the trust store"
  type        = string
}

variable "zone_name" {
  description = "Route53 zone name to register the domain"
  type        = string
}

variable "domain" {
  description = "The domain to be attached to the ALB"
  type        = string
}
