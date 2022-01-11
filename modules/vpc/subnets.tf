resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = var.subnet_a_az
  map_public_ip_on_launch = false

  tags = {
    Name = var.public_subnet_a_name
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = var.subnet_b_az
  map_public_ip_on_launch = false

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