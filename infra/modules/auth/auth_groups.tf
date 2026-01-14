resource "aws_cognito_user_group" "groups" {
  for_each = toset(var.auth_group_names)

  user_pool_id = aws_cognito_user_pool.users.id
  name = each.key
}