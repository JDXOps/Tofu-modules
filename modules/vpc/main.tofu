locals {
  azs                = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
  public_subnet_map  = zipmap(local.azs, var.public_subnet_cidrs)
  private_subnet_map = zipmap(local.azs, var.private_subnet_cidrs)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.vpc_name 
  }
}

resource "aws_subnet" "public" {
  for_each          = local.public_subnet_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = var.public_subnet_tags

}

resource "aws_subnet" "private" {
  for_each          = local.private_subnet_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = var.private_subnet_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "non_ha_ngw_eip" {
  count  = var.enable_ha_ngw ? 0 : 1
  domain = "vpc"
}

resource "aws_nat_gateway" "non_ha_ngw" {
  count         = var.enable_ha_ngw ? 0 : 1
  allocation_id = aws_eip.non_ha_ngw_eip[0].id
  subnet_id     = values(aws_subnet.public)[0].id
}

resource "aws_eip" "ha_ngw_eip" {
  count  = var.enable_ha_ngw ? length(local.public_subnet_map) : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "ha_ngw" {
  for_each      = var.enable_ha_ngw ? local.public_subnet_map : {}
  allocation_id = element(aws_eip.ha_ngw_eip.*.id, index(keys(local.public_subnet_map), each.key))
  subnet_id     = aws_subnet.public[each.key].id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
    type = "public"
  }
}

resource "aws_route_table_association" "public_rt_associations" {
  for_each       = local.public_subnet_map
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
  for_each = local.private_subnet_map
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "private"
    type = "private"
  }

}


resource "aws_route" "private" {
  for_each               = local.private_subnet_map
  route_table_id         = aws_route_table.private_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.enable_ha_ngw ? aws_nat_gateway.ha_ngw[each.key].id : aws_nat_gateway.non_ha_ngw[0].id

}


resource "aws_route_table_association" "private" {
  for_each       = local.private_subnet_map
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_rt[each.key].id
}


