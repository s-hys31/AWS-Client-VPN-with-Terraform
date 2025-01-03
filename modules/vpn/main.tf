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
    saml_provider_arn              = var.saml_provider_arn
    self_service_saml_provider_arn = var.self_service_saml_provider_arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.vpn.name
  }

  security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.prefix} VPN Endpoint"
  }
}

resource "aws_cloudwatch_log_group" "vpn" {
  name              = "/aws/ec2/client-vpn-connections-${random_id.main.hex}"
  retention_in_days = 90
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
