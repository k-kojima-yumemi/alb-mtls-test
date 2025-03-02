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
  function_name = "kkojima-alb-mtls-test-function"
}

# Lambda Module
module "lambda" {
  source = "./modules/lambda"

  function_name = local.function_name
}
