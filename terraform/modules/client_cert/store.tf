resource "aws_s3_bucket" "store" {
  bucket = var.trust_store_s3_name
}

resource "aws_s3_object" "root_ca_cert" {
  bucket  = aws_s3_bucket.store.bucket
  key     = "root_ca.cert"
  content = tls_self_signed_cert.root.cert_pem
}

resource "aws_lb_trust_store" "store" {
  name = var.trust_store_name

  ca_certificates_bundle_s3_bucket = aws_s3_object.root_ca_cert.bucket
  ca_certificates_bundle_s3_key    = aws_s3_object.root_ca_cert.key
}
