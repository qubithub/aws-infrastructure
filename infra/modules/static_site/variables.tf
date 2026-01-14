variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "page_url" {
  description = "desired url of the static site"
  type = string
}

variable "hosted_zone_id" {
  description = "hosted zone id"
  type = string
}

variable "acm_certificate_arn" {
  description = "ARN of certificate covering hosted zone"
  type = string
}