resource "aws_ec2_client_vpn_endpoint" "main" {
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = "10.10.0.0/22"
  vpc_id                 = var.vpc_id
  split_tunnel           = false
  session_timeout_hours  = 24
  vpn_port               = 443
  self_service_portal    = "enabled"
  dns_servers            = var.dns_servers

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = aws_iam_saml_provider.main.arn
    self_service_saml_provider_arn = aws_iam_saml_provider.self_service_portal.arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.vpn.name
  }

  security_group_ids = [aws_security_group.vpn.id]

  tags = {
    Name = "${var.prefix} VPN Endpoint"
  }
}

resource "aws_iam_saml_provider" "main" {
  name                   = "${random_id.main.hex}-saml-provider"
  saml_metadata_document = file("${path.root}/saml-metadata.xml")

  tags = {
    Name = "${var.prefix} SAML Provider"
  }
}

resource "aws_iam_saml_provider" "self_service_portal" {
  name                   = "${random_id.main.hex}-self-service-portal-saml-provider"
  saml_metadata_document = file("${path.root}/self-service-portal-saml-metadata.xml")

  tags = {
    Name = "${var.prefix} Self Service Portal SAML Provider"
  }
}

resource "aws_cloudwatch_log_group" "vpn" {
  name              = "/aws/ec2/client-vpn-connections-${random_id.main.hex}"
  retention_in_days = 90
}

resource "aws_security_group" "vpn" {
  vpc_id = var.vpc_id

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
    cidr_blocks = [var.private_subnet_cidr_block]
  }

  tags = {
    Name = "${var.prefix} VPN Security Group"
  }
}


resource "aws_ec2_client_vpn_network_association" "vpn_to_private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  subnet_id              = var.subnet_id
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn_to_private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "vpn_to_private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.main.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = var.subnet_id

  depends_on = [aws_ec2_client_vpn_network_association.vpn_to_private]
}

resource "random_id" "main" {
  byte_length = 8
}
