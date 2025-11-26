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

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"

  default_tags {
    tags = {
      Environment = var.environment
      SourceRepo  = "aws-infrastructure"
    }
  }
}