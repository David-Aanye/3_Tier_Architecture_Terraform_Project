#App-tier and web-tier subnets configuration
resource "aws_subnet" "webtier1" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.webtier_subnets_cidr[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = var.webtier_subnets_names[0]
  }
}

resource "aws_subnet" "webtier2" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.webtier_subnets_cidr[1]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = var.webtier_subnets_names[1]
  }
}

resource "aws_subnet" "apptier1" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.apptier_subnets_cidr[0]
  availability_zone = var.availability_zone[0]
  tags = {
    Name = var.apptier_subnets_names[0]
  }
}


resource "aws_subnet" "apptier2" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.apptier_subnets_cidr[1]
  availability_zone = var.availability_zone[1]
  tags = {
    Name = var.apptier_subnets_names[1]
  }
}

resource "aws_subnet" "dbtier1" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.dbtier_subnets_cidr[0]
  availability_zone = var.availability_zone[0]
  tags = {
    Name = var.dbtier_subnets_names[0]
  }
}


resource "aws_subnet" "dbtier2" {
  vpc_id            = aws_vpc.terra.id
  cidr_block        = var.dbtier_subnets_cidr[1]
  availability_zone = var.availability_zone[1]
  tags = {
    Name = var.dbtier_subnets_names[1]
  }
}