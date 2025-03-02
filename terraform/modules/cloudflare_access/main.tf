terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

data "cloudflare_zone" "zone" {
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_zero_trust_access_application" "main" {
  zone_id          = data.cloudflare_zone.zone.zone_id
  name             = var.application_name
  domain           = var.cloudflare_domain
  type             = "self_hosted"
  session_duration = "72h"
  policies = [
    cloudflare_zero_trust_access_policy.allow.id,
    // cloudflare_zero_trust_access_policy.bypass.id,
  ]
}

resource "cloudflare_zero_trust_access_policy" "allow" {
  account_id = data.cloudflare_zone.zone.account_id
  name       = "Allow Policy for ${var.application_name}"
  decision   = "allow"
  include {
    email        = var.email_list
    email_domain = var.email_domain_list
  }
  lifecycle { create_before_destroy = true }
}

/*resource "cloudflare_zero_trust_access_policy" "bypass" {
  account_id = data.cloudflare_zone.zone.account_id
  name       = "Bypass Policy for ${var.application_name}"
  decision   = "bypass"
  include {
    ip = var.bypass_ip_list
  }
  lifecycle { create_before_destroy = true }
}*/
