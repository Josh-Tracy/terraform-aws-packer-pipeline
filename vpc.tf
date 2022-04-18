#----------------------------------------------------#
# vpc config
#----------------------------------------------------#
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_b_name
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_c_cidr
  availability_zone       = var.subnet_c_az
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_c_name
  }
}

#----------------------------------------------------#
# networking config
#----------------------------------------------------#

resource "aws_route_table" "subnet_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.subnet_a_routetable_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.subnet_a_routetable_tag_name
  }
}

resource "aws_route_table" "subnet_b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.subnet_b_routetable_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.subnet_b_routetable_tag_name
  }
}

resource "aws_route_table" "subnet_c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.subnet_c_routetable_cidr
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = var.subnet_c_routetable_tag_name
  }
}

resource "aws_route_table_association" "subnet_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.subnet_a.id
}

resource "aws_route_table_association" "subnet_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.subnet_b.id
}


resource "aws_route_table_association" "subnet_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.subnet_c.id
}

#----------------------------------------------------#
# Gateways config
#----------------------------------------------------#

resource "aws_eip" "natgw_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.subnet_a.id

  tags = {
    Name = var.natgw_tag_name
  }

  depends_on = [
	  aws_internet_gateway.igw,
	  aws_eip.natgw_eip,
	  aws_subnet.subnet_a
	  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_tag_name
  }
}

#----------------------------------------------------#
# Security group config
#----------------------------------------------------#
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