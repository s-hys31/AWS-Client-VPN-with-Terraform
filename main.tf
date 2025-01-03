terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Terraform = "true"
    }
  }
}

data "aws_acm_certificate" "server" {
  domain   = var.server_certificate_domain
  statuses = ["ISSUED"]
}

data "aws_iam_saml_provider" "saml_provider" {
  arn = var.saml_provider_arn
}

data "aws_iam_saml_provider" "self_service_saml_provider" {
  arn = var.self_service_saml_provider_arn
}
