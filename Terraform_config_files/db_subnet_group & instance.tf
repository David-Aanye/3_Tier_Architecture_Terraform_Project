# Database subnet group
resource "aws_db_subnet_group" "dbtier" {
  name       = var.db_subnet_grp_name
  subnet_ids = [aws_subnet.dbtier1.id, aws_subnet.dbtier2.id]

  tags = {
    Name = var.db_subnet_grp_name
  }
}


# Rds instance
resource "aws_db_instance" "dbtier" {
  allocated_storage           = 20
  db_name                     = "my_rds_db"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  db_subnet_group_name        = aws_db_subnet_group.dbtier.name
  username                    = var.db-username
  manage_master_user_password = true
  parameter_group_name        = "default.mysql8.0"
  identifier                  = "my-rds-db"
  multi_az                    = true
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_security_group.dbtier_sg.id]

}


