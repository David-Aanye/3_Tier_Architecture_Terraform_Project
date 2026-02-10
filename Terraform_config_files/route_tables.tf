# Route table configurations
resource "aws_route_table" "webtier_AZ" {
  vpc_id = aws_vpc.terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webtier_gw.id
  }
  tags = {
    Name = var.route_table_names[0]

  }
}

resource "aws_route_table" "apptier1_AZ1" {
  vpc_id = aws_vpc.terra.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.webtier1_AZ1.id
  }
  tags = {
    Name = var.route_table_names[1]

  }
}



resource "aws_route_table" "apptier2_AZ2" {
  vpc_id = aws_vpc.terra.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.webtier2_AZ2.id
  }
  tags = {
    Name = var.route_table_names[2]

  }
}

