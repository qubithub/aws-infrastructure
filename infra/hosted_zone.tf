resource "aws_route53_zone" "subdomain" {
  name = var.hosted_zone
}

output "subdomain_nameservers" {
  value = aws_route53_zone.subdomain.name_servers
}

resource "aws_route53_record" "initial_record_root" {
  zone_id = aws_route53_zone.subdomain.zone_id
  name    = var.hosted_zone
  type    = "A"
  ttl     = 300
  records = ["192.0.2.1"]
}
