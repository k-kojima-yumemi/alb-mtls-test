output "root_ca_cert" {
  description = "The Root CA certificate in PEM format"
  value       = tls_self_signed_cert.root.cert_pem
  sensitive   = true
}

output "root_ca_key" {
  description = "The Root CA private key in PEM format"
  value       = tls_self_signed_cert.root.private_key_pem
  sensitive   = true
}

output "client_cert" {
  description = "The client certificate in PEM format"
  value       = tls_locally_signed_cert.client.cert_pem
  sensitive   = true
}

output "client_key" {
  description = "The client private key in PEM format"
  value       = tls_private_key.client.private_key_pem
  sensitive   = true
}

output "trust_store_arn" {
  value = aws_lb_trust_store.store.arn
}
