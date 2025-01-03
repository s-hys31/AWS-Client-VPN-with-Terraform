variable "server_certificate_domain" {
  description = "The domain of the server certificate"
  type        = string
}

variable "saml_provider_arn" {
  description = "The ARN of the SAML provider for authentication"
  type        = string
}

variable "self_service_saml_provider_arn" {
  description = "The ARN of the SAML provider for self-service authentication"
  type        = string
}
