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

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "The CIDR block of the private subnet"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}
