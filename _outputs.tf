output "cf_domain_name" {
  description = "CloudFront Domain Name"
  value       = var.module_enabled ? aws_cloudfront_distribution.default[0].domain_name : null
}
