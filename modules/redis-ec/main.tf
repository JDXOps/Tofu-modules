resource "aws_elasticache_cluster" "example" {
  cluster_id           = var.name
  engine               = var.engine
  engine_version       = var.engine_version
  node_type            = "cache.m4.large"
  num_cache_nodes      = var.num_nodes
  apply_immediately    = var.apply_immediately
  maintenance_window   = var.maintenance_window
  parameter_group_name = "default.memcached1.4"
  subnet_group_name    = aws_elasticache_subnet_group.subnet_group.name
  port                 = var.port
  security_group_ids   = [aws_security_group.ec_sg.id]
  tags                 = var.tags
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "ec_sg" {
  name        = "${var.name}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_db_subnet_group.subnet_group.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "from_cidrs" {

  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = each.value
  from_port         = var.port
  to_port           = var.port
  ip_protocol       = "tcp"
}

