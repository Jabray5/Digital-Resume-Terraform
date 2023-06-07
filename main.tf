// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region  = "eu-west-1"
  profile = "WebApp"
}

module "static-website-bucket-www" {
  source         = "./modules/static_website_s3"
  bucket-name    = var.www_domain_name
  cloudfront_oai = module.static_website_cloudfront.cloudfront_oai_arn
}

module "static_website_cloudfront" {
  source             = "./modules/static_website_cloudfront"
  bucket_domain_name = module.static-website-bucket-www.www_s3_domain
  www_domain_name = var.www_domain_name
  root_domain_name = var.root_domain_name
}

module "static_website_route53" {
  source             = "./modules/static_website_route53"
  www_domain         = var.www_domain_name
  root_domain        = var.root_domain_name
  cdn_domain_name    = module.static_website_cloudfront.cdn_domain_name
  cdn_hosted_zone_id = module.static_website_cloudfront.cdn_hosted_zone_id
}