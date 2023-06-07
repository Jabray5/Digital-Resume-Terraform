provider "aws" {
  region     = "us-east-1"
  alias      = "virginia"
  profile = "WebApp"
}

resource "aws_acm_certificate" "cert" {
  provider = aws.virginia
  domain_name       = var.www_domain_name
  validation_method = "DNS"
  options {
    
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "cdn" {
  source              = "terraform-aws-modules/cloudfront/aws"
  comment             = "Cloudfront Distribution for static S3 website"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  wait_for_deployment = false
  aliases = [
    var.www_domain_name,
    var.root_domain_name
  ]

  viewer_certificate = {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  create_origin_access_identity = true

  origin_access_identities = {
    static_website_s3 = "Cloudfront can access S3 bucket"
  }

  default_root_object = "index.html"

  origin = {
    static_website_s3 = {
      domain_name = var.bucket_domain_name
      s3_origin_config = {
        origin_access_identity = "static_website_s3"
        # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "static_website_s3" # key in `origin` above
    viewer_protocol_policy = "redirect-to-https"

    default_ttl = 5400
    min_ttl     = 3600
    max_ttl     = 7200

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = false

  }

  custom_error_response = [
    {
      error_caching_min_ttl = 3600
      error_code            = 403
      response_code         = 404
      response_page_path    = "/404.html"
    },
    {
      error_caching_min_ttl = 3600
      error_code            = 404
      response_code         = 404
      response_page_path    = "/404.html"
    },
  ]

}