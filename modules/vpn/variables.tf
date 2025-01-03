variable "prefix" {
  description = "The prefix for the resources"
  type        = string
}

variable "server_certificate_arn" {
  description = "The ARN of the server certificate"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "dns_servers" {
  description = "The DNS servers for the VPN"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "saml_provider_arn" {
  description = "The ARN of the SAML provider"
  type        = string
}

variable "self_service_saml_provider_arn" {
  description = "The ARN of the self-service SAML provider"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
