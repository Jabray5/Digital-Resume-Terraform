output "cloudfront_oai_arn" {
  value = module.cdn.cloudfront_origin_access_identity_iam_arns
}

output "cdn_domain_name" {
  value = module.cdn.cloudfront_distribution_domain_name
}

output "cdn_hosted_zone_id" {
  value = module.cdn.cloudfront_distribution_hosted_zone_id
}