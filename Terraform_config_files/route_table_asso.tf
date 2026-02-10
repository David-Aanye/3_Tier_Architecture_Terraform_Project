#Associate route tables
resource "aws_route_table_association" "webtier1" {
  subnet_id      = aws_subnet.webtier1.id
  route_table_id = aws_route_table.webtier_AZ.id
  
}

resource "aws_route_table_association" "webtier2" {
  subnet_id      = aws_subnet.webtier2.id
  route_table_id = aws_route_table.webtier_AZ.id

}

resource "aws_route_table_association" "apptier1_AZ1" {
  subnet_id      = aws_subnet.apptier1.id
  route_table_id = aws_route_table.apptier1_AZ1.id

}


resource "aws_route_table_association" "apptier2_AZ2" {
  subnet_id      = aws_subnet.apptier2.id
  route_table_id = aws_route_table.apptier2_AZ2.id

}