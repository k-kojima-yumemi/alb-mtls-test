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

locals {
  base_name              = var.base_name
  function_name          = "${local.base_name}-function"
  alb_name               = "${local.base_name}-alb"
  domain                 = "${local.base_name}.${var.host_zone_name}"
  trust_store_name       = "${local.base_name}-mtls"
  trust_store_buket_name = "${local.trust_store_name}-bucket"
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name = local.function_name
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

# Just for local testing
resource "local_sensitive_file" "key" {
  filename = "client_cert.key"
  content  = module.client_cert.client_key
}
resource "local_sensitive_file" "cert" {
  filename = "client_cert.cert"
  content  = module.client_cert.client_cert
}
