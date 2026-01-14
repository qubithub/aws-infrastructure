variable "environment" {
  type     = string
  nullable = false
}

variable "hosted_zone" {
  type     = string
  nullable = false
}

variable "sites_with_auth" {
  type        = list(any)
  description = "sites requiring access to cognito managed auth"
}

variable "designer_url" {
  type = string
  description = "the url for the designer homepage"
}