output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "database_subnet_ids" {
  value = [aws_subnet.database.id, aws_subnet.database_2.id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}