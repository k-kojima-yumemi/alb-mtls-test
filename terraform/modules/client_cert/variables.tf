variable "organization" {
  description = "Organization name for the certificates"
  type        = string
  default     = "My Organization"
}

variable "root_common_name" {
  description = "Common name for the root CA certificate"
  type        = string
  default     = "Root CA"
}

variable "client_common_name" {
  description = "Common name for the client certificate"
  type        = string
  default     = "Client Certificate"
}

variable "trust_store_name" {
  description = "Trust store name"
  type        = string
}

variable "trust_store_s3_name" {
  description = "S3 bucket name for the trust store"
  type        = string
}