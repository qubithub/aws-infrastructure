resource "aws_route53_zone" "subdomain" {
  name = var.hosted_zone
}

output "subdomain_nameservers" {
  value = aws_route53_zone.subdomain.name_servers
}
