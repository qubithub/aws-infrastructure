resource "aws_cognito_user_pool" "users" {
  name = "qubithub-users"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection      = "ACTIVE"

  password_policy {
    minimum_length    = 16
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true

  }

  verification_message_template {
    email_message = "Welcome to QComposer! Your login code is {####}"
    email_subject = "Your QComposer Acount is Almost Ready"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  user_pool_tier = "LITE"

  mfa_configuration = "OFF"
}

resource "aws_cognito_user_pool_domain" "user-domain" {
  domain          = "auth.${var.hosted_zone}"
  certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id    = aws_cognito_user_pool.users.id
}

resource "aws_route53_record" "auth-cognito_A" {
  name    = aws_cognito_user_pool_domain.user-domain.domain
  type    = "A"
  zone_id = aws_route53_zone.subdomain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.user-domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.user-domain.cloudfront_distribution_zone_id
  }
}