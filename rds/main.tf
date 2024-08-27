resource "aws_db_instance" "rds" {
  identifier             = var.identifier
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  engine                 = var.engine
  engine_version         = "8.0.35"
  vpc_security_group_ids = [var.application-sg]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot    = true
  tags = {
    Name = "application-rds"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "database-subnets-group"
  subnet_ids = [var.privateSubnet1, var.privateSubnet2]
  tags = {
    Name = "Database-subnets-group"
  }
}


output "rds-endpoint" {
  value = element(split(":", aws_db_instance.rds.endpoint), 0)
  # value = aws_db_instance.rds.id
}


