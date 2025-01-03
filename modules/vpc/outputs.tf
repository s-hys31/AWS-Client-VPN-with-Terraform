output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "security_group_vpn_id" {
  description = "The ID of the VPN security group"
  value       = aws_security_group.vpn.id
}
