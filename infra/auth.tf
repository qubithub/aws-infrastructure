locals {
  callback_urls = [for url in var.sites_with_auth : "${url}/logincallback"]
}

data "archive_file" "new_users_default_students_group" {
  type        = "zip"
  source_file = "lambda/new_user_students_group.mjs"
  output_path = "zip/new_user_students_group.zip"
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:AdminAddUserToGroup",
          "cognito-idp:AdminGetUser",
          "cognito-idp:AdminListGroupsForUser",
          "cognito-idp:GetUserPoolMfaConfig"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_role" {
  name = "cognito-post-confirmation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_lambda_function" "new_users_default_students_group" {
  function_name = "new_users_default_students_group"

  filename         = data.archive_file.new_users_default_students_group.output_path
  source_code_hash = data.archive_file.new_users_default_students_group.output_base64sha256

  handler = "new_user_students_group.handler"
  runtime = "nodejs18.x"

  role = aws_iam_role.lambda_role.arn

  timeout = 10
}

resource "aws_lambda_permission" "allow_cognito_post_confirmation" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.new_users_default_students_group.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.users.arn
}

resource "aws_cognito_user_pool" "users" {
  name = "qubithub-users"

  lambda_config {
    post_confirmation = aws_lambda_function.new_users_default_students_group.arn
  }

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
  certificate_arn = aws_acm_certificate.composer.arn
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
  image_file   = filebase64("assets/qubithub.png")
}

output "auth_client_id" {
  value = aws_cognito_user_pool_client.clients.id
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