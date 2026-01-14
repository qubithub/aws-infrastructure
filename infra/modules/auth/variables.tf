variable "sites_with_auth" {
  type        = list(any)
  description = "sites requiring access to cognito managed auth"
}

variable "auth_domain_name" {
    type = string
    description = "the url of the hosted auth site"
}

variable "hosted_zone_certificate_arn" {
    type = string
    description = "arn of the certificate to be applied to the auth_domain_name"
}

variable "user_pool_name" {
    type = string
    description = "The name of the user pool"
}

variable "auth_group_names" {
    type = list(string)
    description = "list of names for user groups"
}

variable "custom_login_image" {
    type = string
    description = "base 64 string representing the desired image"
}

variable "hosted_zone_id" {
    type = string
    description = "ARN of the hosted zone"
    nullable = false
}