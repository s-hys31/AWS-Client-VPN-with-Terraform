resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix} VPN VPC"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.prefix} VPN Private Subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${var.prefix} VPN Public Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix} VPN IGW"
  }
}

resource "aws_route_table" "vpc_to_internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.prefix} VPN Public Route Table"
  }
}

resource "aws_route_table_association" "public_to_internet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.vpc_to_internet.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = var.aws_eip_nat_id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${var.prefix} VPN NAT Gateway"
  }
}

resource "aws_route_table" "private_to_nat" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.prefix} VPN Private Route Table"
  }
}

resource "aws_route_table_association" "private_to_nat" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_to_nat.id
}

resource "aws_security_group" "vpn" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }

  tags = {
    Name = "${var.prefix} VPN Security Group"
  }
}
