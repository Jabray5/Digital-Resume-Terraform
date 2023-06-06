output "cloudfront_oai_arn" {
  value = module.cdn.cloudfront_origin_access_identity_iam_arns
}