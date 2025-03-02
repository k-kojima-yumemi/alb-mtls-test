variable "cloudflare_zone_name" {
  description = "The name of the Cloudflare Zone to create"
  type        = string
}

variable "cloudflare_account_id" {
  description = "The ID of the Cloudflare Account"
  type        = string
}

variable "host_zone_name" {
  description = "The name of the Route53 Hosted Zone for NS records"
  type        = string
}

variable "client_cert" {
  description = "The client certificate to access ALB"
  type        = string
}

variable "client_key" {
  description = "The client private key to access ALB"
  type        = string
}

variable "domain" {
  description = "The application domain registered in Route53"
  type        = string
}

variable "cloudflare_domain" {
  description = "The application domain to be registered in Cloudflare"
  type        = string
}
