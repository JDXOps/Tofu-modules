output "vpc_id" {
  description = "The AWS given ID of the provisioned VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the provisioned public subnets"
  value       = [for v in aws_subnet.public : v.id]
}

output "private_subnet_ids" {
  description = "The IDs of the provisioned private subnets"
  value       = [for v in aws_subnet.private : v.id]
}