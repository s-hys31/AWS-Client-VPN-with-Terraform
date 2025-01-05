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

data "aws_eip" "static_ip" {
  public_ip = var.aws_eip_static_ip
}

module "vpc" {
  source = "./modules/vpc"

  prefix         = "VPN"
  aws_eip_nat_id = data.aws_eip.static_ip.id
}

module "vpn" {
  source = "./modules/vpn"

  private_subnet_cidr_block = module.vpc.private_subnet_cidr_block
  prefix                    = "VPN"
  server_certificate_arn    = data.aws_acm_certificate.server.arn
  vpc_id                    = module.vpc.vpc_id
  security_group_id         = module.vpc.security_group_id
  subnet_id                 = module.vpc.subnet_id
}
