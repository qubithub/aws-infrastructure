resource "aws_acm_certificate" "composer" {
  provider          = aws.us_east_1
  domain_name       = "*.${var.hosted_zone}"
  validation_method = "DNS"
}

resource "aws_route53_record" "composer_validation" {
  for_each = {
    for dvo in aws_acm_certificate.composer.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.subdomain.zone_id
}

resource "aws_acm_certificate_validation" "composer_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.composer.arn
  validation_record_fqdns = [for record in aws_route53_record.composer_validation : record.fqdn]
}
