output "subdomain_nameservers" {
  value = aws_route53_zone.subdomain.name_servers
}

output "hosted_zone" {
    value = aws_route53_zone.subdomain.name
}

output "hosted_zone_id" {
    value = aws_route53_zone.subdomain.id
}