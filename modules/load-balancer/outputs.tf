output "alb-dns-name" {
  value = aws_lb.alb.dns_name
  description = "DNS of Application"
}

output "nlb-dns-name" {
  value = aws_lb.nlb.dns_name
  description = "DNS of backend"
}
