variable "server_certificate_domain" {
  description = "The domain of the server certificate"
  type        = string
}

variable "aws_eip_static_ip" {
  description = "The static IP address for the NAT Gateway"
  type        = string
}
