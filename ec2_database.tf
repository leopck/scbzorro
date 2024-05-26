resource "aws_db_subnet_group" "mydb_subnet_group" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.app_vpc.id, aws_subnet.app_vpc_2.id]

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_db_instance" "example" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.dbusername
  password             = aws_secretsmanager_secret_version.example.secret_string
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  db_subnet_group_name = aws_db_subnet_group.mydb_subnet_group.name
}