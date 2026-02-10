# Internet gateway for public subnets
resource "aws_internet_gateway" "webtier_gw" {
  vpc_id = aws_vpc.terra.id

  tags = {
    Name = var.internet_gateway
  }

}

