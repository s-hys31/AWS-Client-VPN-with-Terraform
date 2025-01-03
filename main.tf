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

data "aws_acm_certificate" "issued" {
  domain   = var.domain
  statuses = ["ISSUED"]
}
