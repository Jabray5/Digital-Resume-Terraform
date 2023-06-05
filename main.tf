// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region  = "eu-west-1"
  profile = "WebApp"
}

resource "aws_s3_bucket" "www" {
  bucket = var.www_domain_name
}

resource "aws_s3_bucket_policy" "www-policy" {
  bucket = aws_s3_bucket.www.bucket

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
  bucket = aws_s3_bucket.www.bucket

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