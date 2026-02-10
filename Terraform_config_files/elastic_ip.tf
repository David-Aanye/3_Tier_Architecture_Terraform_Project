# Elastic IPs
resource "aws_eip" "webtier1" {
  domain = "vpc"
  tags = {
    Name = var.elastic_ip[0]
  }
}

resource "aws_eip" "webtier2" {
  domain = "vpc"

  tags = {
    Name = var.elastic_ip[1]
  }
}