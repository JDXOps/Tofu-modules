resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}


resource "aws_db_instance" "db_instance" {
  identifier            = var.identifier
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_subnet_group_name  = aws_db_subnet_group.subnet_group.id
  deletion_protection   = var.enable_deletion_protection
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  multi_az              = var.enable_multi_az
  username              = var.master_user_username
  password              = var.master_user_password
  option_group_name     = var.option_group_name
  parameter_group_name  = var.parameter_group_name
  port                  = var.port
  tags                  = var.tags
}