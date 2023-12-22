output "vpc_arn" {
  value = aws_vpc.created_vpc.arn
}

output "vpc_id" {
  value = aws_vpc.created_vpc.id
}

output "main_route_table_id" {
  value =  aws_vpc.created_vpc.main_route_table_id
}

output "public_subnet_arn" {
  value = aws_subnet.public_subnet.arn
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_arn" {
  value = aws_subnet.private_subnet.arn
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
