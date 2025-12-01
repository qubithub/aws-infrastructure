resource "aws_cognito_user_group" "students" {
  user_pool_id = aws_cognito_user_pool.users.id
  name         = "students"
}

resource "aws_cognito_user_group" "researchers" {
  user_pool_id = aws_cognito_user_pool.users.id
  name         = "researchers"
}

resource "aws_cognito_user_group" "admins" {
  user_pool_id = aws_cognito_user_pool.users.id
  name         = "admins"
}