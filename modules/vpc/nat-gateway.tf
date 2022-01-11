
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