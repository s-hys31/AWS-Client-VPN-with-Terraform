output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_cidr_blocks" {
  description = "The CIDR blocks of the private subnets"
  value       = aws_subnet.private.cidr_block
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.private.id
}
