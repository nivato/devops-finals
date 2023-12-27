output "instance_address" {
  value = aws_db_instance.mysql.address
}

output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "instance_id" {
  value = aws_db_instance.mysql.id
}

output "instance_arn" {
  value = aws_db_instance.mysql.arn
}
