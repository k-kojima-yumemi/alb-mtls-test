variable "cloudflare_zone_id" {
  description = "The id of the Cloudflare Zone"
  type        = string
}

variable "application_name" {
  description = "The name of the Cloudflare Access Application"
  type        = string
}

variable "cloudflare_domain" {
  description = "The domain registered in Cloudflare"
  type        = string
}

variable "email_list" {
  description = "Allowed email addresses"
  type        = list(string)
  default     = []
}

variable "email_domain_list" {
  description = "Allowed email domains"
  type        = list(string)
  default     = []
}

variable "bypass_ip_list" {
  description = "Allowed IP addresses"
  type        = list(string)
  default     = []
}