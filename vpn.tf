resource "aws_ec2_client_vpn_endpoint" "main" {
  description            = "Main Client VPN Endpoint"
  server_certificate_arn = data.aws_acm_certificate.issued.arn
  client_cidr_block      = "10.0.0.0/16"

  vpc_id = aws_vpc.main.id

  split_tunnel          = false
  session_timeout_hours = 24
  vpn_port              = 443

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = data.aws_iam_saml_provider.sp.arn
    self_service_saml_provider_arn = data.aws_iam_saml_provider.s3p.arn
  }

  connection_log_options {
    enabled = false
  }

  security_group_ids = [aws_security_group.vpn.id]
}

data "aws_iam_saml_provider" "sp" {
  arn = var.saml_provider_arn
}

data "aws_iam_saml_provider" "s3p" {
  arn = var.self_service_saml_provider_arn
}

resource "aws_security_group" "vpn" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_to_private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  subnet_id              = aws_subnet.private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "allow_all_users" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "vpn_to_private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_subnet.private.id
}
