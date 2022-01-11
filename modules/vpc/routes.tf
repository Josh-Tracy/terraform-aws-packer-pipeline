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

# Create Route Table Association for dev1-subnet to dev-rt
resource "aws_route_table_association" "subnet_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.subnet_c.id
}