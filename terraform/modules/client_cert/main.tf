terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Root CA private key
resource "tls_private_key" "root" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Root CA certificate
resource "tls_self_signed_cert" "root" {
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = var.root_common_name
    organization = var.organization
    country      = "jp"
    locality     = "tokyo"
  }

  validity_period_hours = 43824 # 1826 days
  is_ca_certificate     = true

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}


# Client private key
resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem
  subject {
    common_name  = var.client_common_name
    organization = var.organization
    country      = "jp"
    locality     = "tokyo"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem      = tls_cert_request.client.cert_request_pem
  ca_cert_pem           = tls_self_signed_cert.root.cert_pem
  ca_private_key_pem    = tls_self_signed_cert.root.private_key_pem
  is_ca_certificate     = false
  validity_period_hours = 17520 # 730 days
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "client_auth",
  ]
}
