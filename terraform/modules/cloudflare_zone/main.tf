terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Create Cloudflare zone
/*resource "cloudflare_zone" "zone" {
  zone       = var.cloudflare_zone_name
  account_id = var.cloudflare_account_id
}

resource "cloudflare_zone_settings_override" "zone" {
  zone_id = cloudflare_zone.zone.id
  settings {
    tls_client_auth    = "on"
    ssl_automatic_mode = "custom"
    ssl                = "strict"
  }
}*/
data "cloudflare_zone" "zone" {
  name = var.cloudflare_zone_name
}
locals {
  zone_id = data.cloudflare_zone.zone.id
}

resource "cloudflare_record" "main" {
  name    = var.cloudflare_domain
  type    = "CNAME"
  zone_id = local.zone_id
  content = var.domain
  proxied = true
}

/*# Get Route53 hosted zone
data "aws_route53_zone" "host_zone" {
  name = var.host_zone_name
}

# Create NS record in Route53 for Cloudflare zone
resource "aws_route53_record" "cloudflare_ns" {
  zone_id = data.aws_route53_zone.host_zone.zone_id
  name    = var.cloudflare_zone_name
  type    = "NS"
  ttl     = "300"
  records = local.zone_id
}*/
