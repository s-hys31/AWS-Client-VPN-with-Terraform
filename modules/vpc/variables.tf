variable "name_prefix" {
  description = "Prefix for the name of the resources that will be created"
  type        = string
}

variable "aws_eip_nat_id" {
  description = "The Elastic IP to associate with the NAT Gateway"
  type        = string
}
