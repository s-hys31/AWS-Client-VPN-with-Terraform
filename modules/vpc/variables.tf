variable "prefix" {
  description = "The prefix to apply to all resources"
  type        = string
}

variable "aws_eip_nat_id" {
  description = "The Elastic IP to associate with the NAT Gateway"
  type        = string
}
