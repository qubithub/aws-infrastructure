locals {
  callback_urls = [for url in var.sites_with_auth : "${url}/logincallback"]
}

resource "aws_cognito_user_pool" "users" {
  name = var.user_pool_name

  lambda_config {
    post_confirmation = aws_lambda_function.post_confirmation.arn
  }

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection      = "INACTIVE"

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
  domain          = var.auth_domain_name
  certificate_arn = var.hosted_zone_certificate_arn
  user_pool_id    = aws_cognito_user_pool.users.id
}

resource "aws_cognito_user_pool_client" "clients" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.users.id
  callback_urls                        = local.callback_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_ui_customization" "customization" {
  user_pool_id = aws_cognito_user_pool_domain.user-domain.user_pool_id
  image_file   = var.custom_login_image
  depends_on = [ aws_cognito_user_pool_domain.user-domain ]
}

resource "aws_route53_record" "auth-cognito_A" {
  name    = aws_cognito_user_pool_domain.user-domain.domain
  type    = "A"
  zone_id = var.hosted_zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.user-domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.user-domain.cloudfront_distribution_zone_id
  }
}