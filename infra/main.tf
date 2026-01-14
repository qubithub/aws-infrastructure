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

module "dns" {
  source = "./modules/dns"
  hosted_zone = var.hosted_zone
}

module "certificate" {
  source = "./modules/certificates"
  hosted_zone = module.dns.hosted_zone
  hosted_zone_id = module.dns.hosted_zone_id
  providers = {
    aws.home = aws
    aws.us_east_1 = aws.us_east_1
  }
}


// Static site hosting here
module "designer_home" {
    source = "./modules/static_site"
    name = var.environment
    bucket_name = "qubithub-designer"
    page_url = var.designer_url
    hosted_zone_id = module.dns.hosted_zone_id
    acm_certificate_arn = module.certificate.certificate_arn
}

// Auth server

module "auth" {
  source = "./modules/auth"
  depends_on = [ module.designer_home ]
  sites_with_auth = var.sites_with_auth
  auth_domain_name = "auth.${module.dns.hosted_zone}"
  hosted_zone_certificate_arn = module.certificate.certificate_arn
  user_pool_name = "qubithub-users"
  auth_group_names = [ "students", "researchers", "admins" ]
  custom_login_image = filebase64("assets/qubithub.png")
  hosted_zone_id = module.dns.hosted_zone_id
}

