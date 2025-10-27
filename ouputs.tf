output "vpc_id" {
  value = aws_vpc.main.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
  
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "eip" {
  value = aws_eip.nat-eip.public_ip 
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat-gw.id
}

output "default_vpc_id" {
  value = data.aws_vpc.default_vpc.id
}