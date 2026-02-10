# Nat gateways for private subnets
resource "aws_nat_gateway" "webtier1_AZ1" {
  allocation_id = aws_eip.webtier1.id
  subnet_id     = aws_subnet.webtier1.id

  tags = {

    Name = var.nat_gw[0]
  }
}


resource "aws_nat_gateway" "webtier2_AZ2" {
  allocation_id = aws_eip.webtier2.id
  subnet_id     = aws_subnet.webtier2.id

  tags = {

    Name = var.nat_gw[1]
  }
}