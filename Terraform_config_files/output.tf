

output "vpc_id" {
  value = aws_vpc.terra.id

}

output "internal_alb_dns_name" {
  value = aws_lb.internal_load_balancer.dns_name

}

output "external_alb_dns_name" {
  value = aws_lb.external_load_balancer.dns_name
}

 