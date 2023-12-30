output "frontend-ips" {
  value = [ for i in aws_instance.frontend-servers : i.private_dns ]
}

output "backend-ips" {
  value = [ for i in aws_instance.backend-servers : i.private_dns ]
}

output "bastion-ip" {
  value = aws_instance.bastion-server.public_ip
}

output "alb-dns" {
  value = module.load-balancer.alb-dns-name
}
output "nlb-dns" {
  value = module.load-balancer.nlb-dns-name
}