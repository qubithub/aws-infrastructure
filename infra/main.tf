provider "aws" {
  region  = "mx-central-1"
  profile = "qubithub-staging-admin"

  default_tags {
    tags = {
      Environment = var.environment
      SourceRepo  = "aws-infrastructure"
    }
  }
}
