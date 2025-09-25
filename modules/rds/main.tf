locals {
  selected_kms_key = var.enable_at_rest_encryption && var.create_kms_key == false ? try(var.kms_key_arn, null) : var.enable_at_rest_encryption && var.create_kms_key ? aws_kms_key.kms_key[0].arn : null
}

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
  skip_final_snapshot   = var.skip_final_snapshot
  publicly_accessible   = var.publicly_accessible

  # backups 
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  # at rest encryption 
  storage_encrypted = var.enable_at_rest_encryption
  kms_key_id        = local.selected_kms_key
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.identifier}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_db_subnet_group.subnet_group.vpc_id

  tags = {
    Name = "${var.identifier}-sg"
  }
}

# Allow inbound from CIDRs
resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {
  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = each.value
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
}

# Allow inbound from other SGs
resource "aws_vpc_security_group_ingress_rule" "from_sgs" {
  for_each = toset(var.allowed_ingress_sg_ids)

  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = each.value
  from_port                    = var.port
  to_port                      = var.port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

