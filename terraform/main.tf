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
  base_name     = var.base_name
  function_name = "${local.base_name}-function"
  alb_name      = "${local.base_name}-alb"
  domain        = "${local.base_name}.${var.host_zone_name}"
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

module "alb" {
  source = "./modules/alb"

  certificate_arn = module.cert.certification_arn
  name            = local.alb_name
  subnet_names    = var.subnets
}