#Creacion de la BD MySQL para la app
resource "aws_db_instance" "myinstance" {
  engine                 = "mysql"
  identifier             = var.nombre-bd-mysql
  allocated_storage      = 20
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = var.nombre-bd-mysql
  username               = var.username-bd
  password               = var.password-bd
  parameter_group_name   = "default.mysql5.7"
  multi_az               = false
  vpc_security_group_ids = [var.SGprivado]
  db_subnet_group_name   = aws_db_subnet_group.mysqldb_subnetsprivate.name
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags = {
    Name = "${var.nombre-bd-mysql}"
    Prod = "Back"
  }
}
#Creacion del grupo de subredes para la BD
resource "aws_db_subnet_group" "mysqldb_subnetsprivate" {
  name        = "mysqldb_subnetsprivate"
  description = "Private subnets for RDS instance"
  subnet_ids  = ["${element(var.subnet-privates,0)}","${element(var.subnet-privates,1)}"]
}