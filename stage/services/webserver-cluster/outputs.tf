output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of my load balancer"
}
