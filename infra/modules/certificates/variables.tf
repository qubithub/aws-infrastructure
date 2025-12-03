variable "hosted_zone" {
    type = string
    nullable = false
    description = "The AWS Hosted Zone for which this certificate is valid"
}

variable "hosted_zone_id" {
    type = string
    nullable = false
    description = "The AWS Hosted Zone Id for which this certificate is valid"
}