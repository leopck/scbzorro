resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_http_ipv4_frontend" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_https_ipv4_frontend" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_frontend" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_sshfrontend" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4_backend" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.app_vpc.cidr_block
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.app_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_route_table" "default" {
  vpc_id = aws_vpc.app_vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Create a route in the default route table pointing to the Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = data.aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id
}