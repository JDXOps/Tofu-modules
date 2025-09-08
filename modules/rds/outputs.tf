output "db_endpoint" {
  value       = aws_db_instance.db_instance.endpoint
  description = "The DNS address of the DB instance"
}

output "db_name" {
  value       = aws_db_instance.db_instance.db_name
  description = "The database name"
}

output "db_arn" {
  value       = aws_db_instance.db_instance.db_name
  description = "The ARN of the db instance"
}