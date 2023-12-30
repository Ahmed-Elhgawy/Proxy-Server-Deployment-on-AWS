output "vpc-id" {
  value = aws_vpc.web-vpc.id
  description = "The ID of web VPC"
}

# ID of Subnets
output "public-subnets-id" {
  value = [ for s in aws_subnet.public-subnets : s.id ]
  description = "The IDs of Public Subnets"
}
output "private-subnets-id" {
  value = [ for s in aws_subnet.private-subnets : s.id ]
  description = "The IDs of Private Subnets"
}

