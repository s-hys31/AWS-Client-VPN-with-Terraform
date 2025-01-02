variable "domain" {
  description = "The domain name to find a certificate"
  type        = string
}

variable "saml_provider_arn" {
  description = "The ARN of the SAML provider"
  type        = string
}
