variable "base_name" {
  type        = string
  description = "Application base name"
  default     = "example-project-mtls"
}

variable "subnets" {
  type        = list(string)
  description = "The name of the subnets to deploy ALB. Not the subnet IDs."
}

variable "host_zone_name" {
  type        = string
  description = "The name of the Route53 Hosted Zone"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_name" {
  type        = string
  description = "The name of the Cloudflare Zone"
}

variable "cloudflare_account_id" {
  description = "The ID of the Cloudflare Account"
  type        = string
  sensitive   = true
}

variable "access_allowed_email" {
  description = "Allowed email addresses"
  type        = list(string)
  sensitive   = true
}

variable "access_allowed_email" {
  description = "Allowed email addresses"
  type        = list(string)
}
