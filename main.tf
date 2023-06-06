// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region  = "eu-west-1"
  profile = "WebApp"
}

module "static-website-bucket-www" {
  source      = "./modules/static_website_s3"
  bucket-name = var.www_domain_name
}

module "static_website_cloudfront" {
  source             = "./modules/static_website_cloudfront"
  bucket_domain_name = module.static-website-bucket-www.www_s3_domain
}