resource "aws_security_group" "packer_build" {
  name        = "allow_web_ssh"
  description = "Allow https http and ssh from anywhere and ssh internal the VPC CIDR"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = var.https_ingress_rule_description
    from_port   = var.https_from_port
    to_port     = var.https_to_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_https_cidr
  }

  ingress {
    description = var.http_ingress_rule_description
    from_port   = var.http_from_port
    to_port     = var.http_to_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_http_cidr
  }

  ingress {
    description = var.ssh_ingress_rule_description
    from_port   = var.ssh_from_port
    to_port     = var.ssh_to_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_ssh_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.sg_name_https
  }
}