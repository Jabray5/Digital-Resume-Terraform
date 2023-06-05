// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region  = "eu-west-1"
  profile = "WebApp"
}

// Create a variable for our domain name because we'll be using it a lot.
variable "www_domain_name" {
  default = "www.joeybrayshaw.com"
}

// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  default = "joeybrayshaw.com"
}

resource "aws_s3_bucket" "www" {
  bucket = var.www_domain_name
}

resource "aws_s3_bucket_policy" "www-policy" {
  bucket = var.www_domain_name

  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "s3:GetObject"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "arn:aws:s3:::www.joeybrayshaw.com/*"
          Sid       = "PublicReadGetObject"
        },
      ]
      Version = "2012-10-17"
    }
  )

}

resource "aws_s3_bucket_website_configuration" "www-config" {
  bucket = var.www_domain_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "images/"
    }
    redirect {
      replace_key_prefix_with = "assets/images/"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "www-public-access-block" {
  bucket = var.www_domain_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}