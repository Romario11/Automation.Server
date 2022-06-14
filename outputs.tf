output "Load_balancer_DNS" {
  value = aws_lb.public_alb.dns_name
}