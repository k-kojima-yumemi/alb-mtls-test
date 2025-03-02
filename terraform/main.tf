terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      # Use the last version of v4 as v5 is too unstable
      version = "4.52.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Project   = "alb-mtls-test"
      Terraform = true
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  base_name              = var.base_name
  function_name          = "${local.base_name}-function"
  alb_name               = "${local.base_name}-alb"
  domain                 = "${local.base_name}.${var.host_zone_name}"
  trust_store_name       = "${local.base_name}-mtls"
  trust_store_buket_name = "${local.trust_store_name}-bucket"
  cloudflare_domain      = "alb-mtls-test.${var.cloudflare_zone_name}"
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name = local.function_name
}

# Cloudflare Zone Module
module "cloudflare_zone" {
  source = "./modules/cloudflare_zone"

  cloudflare_zone_name  = var.cloudflare_zone_name
  host_zone_name        = var.host_zone_name
  cloudflare_account_id = var.cloudflare_account_id
  client_cert           = module.client_cert.client_cert
  client_key            = module.client_cert.client_key
  domain                = local.domain
  cloudflare_domain     = local.cloudflare_domain
}

module "cert" {
  source    = "./modules/cert"
  zone_name = var.host_zone_name
  domain    = local.domain
}

module "client_cert" {
  source              = "./modules/client_cert"
  trust_store_name    = local.trust_store_name
  trust_store_s3_name = local.trust_store_buket_name
}

module "alb" {
  source = "./modules/alb"

  certificate_arn = module.cert.certification_arn
  name            = local.alb_name
  subnet_names    = var.subnets
  trust_store_arn = module.client_cert.trust_store_arn
  zone_name       = var.host_zone_name
  domain          = local.domain
}

module "alb_target" {
  source = "./modules/alb_target"

  function_name = module.lambda.function_name
  function_arn  = module.lambda.function_arn
  listener_arn  = module.alb.https_listener_arn
  path_pattern  = "/*"
  priority      = 100
}

# Just for local testing
resource "local_sensitive_file" "key" {
  filename = "client_cert.key"
  content  = module.client_cert.client_key
}
resource "local_sensitive_file" "cert" {
  filename = "client_cert.crt"
  content  = module.client_cert.client_cert
}
