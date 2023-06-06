resource "aws_s3_bucket" "static" {
  bucket = var.bucket-name

  # Allows bucket to be deleted without emptying first
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.static.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.static.bucket
  #   bucket = var.bucket-name
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "s3:GetObject"
          Effect    = "Allow"
          Principal = { AWS = "${var.cloudfront_oai[0]}" }
          Resource  = "arn:aws:s3:::www.joeybrayshaw.com/*"
          Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        },
      ]
      Version = "2012-10-17"
    }
  )
  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.static.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
  #   routing_rule {
  #     condition {
  #       key_prefix_equals = "images/"
  #     }
  #     redirect {
  #       replace_key_prefix_with = "assets/images/"
  #     }
  #   }
  depends_on = [aws_s3_bucket_public_access_block.this]
}

