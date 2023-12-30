output "bastion-sg-id" {
  value = aws_security_group.bastion-sg.id
  description = "The ID of Bastion server security group"
}

output "frontend-sg-id" {
  value = aws_security_group.frontend-sg.id
  description = "The ID of Frontend server security group"
}

output "backend-sg-id" {
  value = aws_security_group.backend-sg.id
  description = "The ID of Backend server security group"
}

output "alb-sg-id" {
  value = aws_security_group.alb-sg.id
  description = "The ID of Application loadbalancer security group"
}

output "nlb-sg-id" {
  value = aws_security_group.nlb-sg.id
  description = "The ID Network loadbalancer security group"
}
