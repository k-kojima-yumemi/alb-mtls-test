resource "cloudflare_authenticated_origin_pulls_certificate" "main" {
  certificate = var.client_cert
  private_key = var.client_key
  type        = "per-hostname"
  zone_id     = local.zone_id
}

resource "cloudflare_authenticated_origin_pulls" "main" {
  enabled                                = true
  zone_id                                = local.zone_id
  authenticated_origin_pulls_certificate = cloudflare_authenticated_origin_pulls_certificate.main.id
  hostname                               = var.cloudflare_domain
  lifecycle {
    replace_triggered_by = [cloudflare_authenticated_origin_pulls_certificate.main]
  }
}
