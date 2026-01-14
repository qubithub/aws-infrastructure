resource "aws_route53_zone" "subdomain" {
  name = var.hosted_zone
}
