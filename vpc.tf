#----------------------------------------------------#
# vpc config
#----------------------------------------------------#
resource "aws_vpc" "vpc" {
  count      = var.create_vpc == true ? 1 : 0
  
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.friendly_name_prefix}-${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet_a" {
  count = var.create_vpc == true ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "subnet_b" {
  count = var.create_vpc == true ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_b_name
  }
}

resource "aws_subnet" "subnet_c" {
  count = var.create_vpc == true ? 1 : 0

  vpc_id                  = aws_vpc.vpc[0].id
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
  count = var.create_vpc == true ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = var.subnet_a_routetable_cidr
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = var.subnet_a_routetable_tag_name
  }
}

resource "aws_route_table" "subnet_b" {
  count = var.create_vpc == true ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = var.subnet_b_routetable_cidr
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = var.subnet_b_routetable_tag_name
  }
}

resource "aws_route_table" "subnet_c" {
  count = var.create_vpc == true ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block     = var.subnet_c_routetable_cidr
    nat_gateway_id = aws_nat_gateway.natgw[0].id
  }

  tags = {
    Name = var.subnet_c_routetable_tag_name
  }
}

resource "aws_route_table_association" "subnet_a" {
  count = var.create_vpc == true ? 1 : 0

  subnet_id      = aws_subnet.subnet_a[0].id
  route_table_id = aws_route_table.subnet_a[0].id
}

resource "aws_route_table_association" "subnet_b" {
  count = var.create_vpc == true ? 1 : 0

  subnet_id      = aws_subnet.subnet_b[0].id
  route_table_id = aws_route_table.subnet_b[0].id
}


resource "aws_route_table_association" "subnet_c" {
  count = var.create_vpc == true ? 1 : 0

  subnet_id      = aws_subnet.subnet_c[0].id
  route_table_id = aws_route_table.subnet_c[0].id
}

#----------------------------------------------------#
# Gateways config
#----------------------------------------------------#

resource "aws_eip" "natgw_eip" {
  count = var.create_vpc == true ? 1 : 0

  vpc = true
}

resource "aws_nat_gateway" "natgw" {
  count = var.create_vpc == true ? 1 : 0

  allocation_id = aws_eip.natgw_eip[0].id
  subnet_id     = aws_subnet.subnet_a[0].id

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
  count = var.create_vpc == true ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = var.igw_tag_name
  }
}

#----------------------------------------------------#
# Security group config
#----------------------------------------------------#
resource "aws_security_group" "codebuild" {

  name        = "${var.friendly_name_prefix}-ingress-ports"
  description = "Securirty group for the AWS Codebuild builds"
  vpc_id      = var.create_vpc == true ? aws_vpc.vpc[0].id : var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = element(var.ingress_ports, index(var.ingress_ports, ingress.value))
      protocol    = "tcp"
      cidr_blocks = var.ingress_allowed_cidr
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Codepipeline Permitted Ports"
  }
}