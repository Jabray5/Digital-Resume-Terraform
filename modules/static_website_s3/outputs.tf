output "www_s3_arn" {
  value = aws_s3_bucket.static.arn
}

output "www_s3_domain" {
  value = aws_s3_bucket.static.bucket_domain_name
}