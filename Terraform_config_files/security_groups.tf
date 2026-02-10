# Security groups configurations 
resource "aws_security_group" "ALB_external_sg" {
  name   = "external_alb_sg"
  vpc_id = aws_vpc.terra.id


  ingress {
    description = "Traffic from HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.security_groups_names[0]
  }

}

resource "aws_security_group" "webtier_sg" {
  name   = "webtier_sg"
  vpc_id = aws_vpc.terra.id


  ingress {
    description     = "Traffic from HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB_external_sg.id]

  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.security_groups_names[1]
  }

}


resource "aws_security_group" "ALB_internal_sg" {
  name   = "internal_ALb_sg"
  vpc_id = aws_vpc.terra.id


  ingress {
    description     = "Traffic from HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.webtier_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = var.security_groups_names[2]

  }

}

resource "aws_security_group" "apptier_sg" {
  name   = "apptier_sg"
  vpc_id = aws_vpc.terra.id


  ingress {
    description     = "Traffic from Custom TCP"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB_internal_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.security_groups_names[3]
  }

}

resource "aws_security_group" "dbtier_sg" {
  name   = "dbtier_sg"
  vpc_id = aws_vpc.terra.id


  ingress {
    description     = "Traffic from MYSQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.apptier_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.security_groups_names[4]
  }

}