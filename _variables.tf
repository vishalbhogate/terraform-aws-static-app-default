variable "name" {}

variable "s3_bucket_id" {}

variable "hostnames" {
  type = list(string)
}

variable "hosted_zone" {}

variable "certificate_arn" {}

variable "hostname_create" {
  description = "Create hostname in the hosted zone passed?"
  default     = true
}

variable "hostname_alias" {
  description = "Create an Alias host in route53 for Cloudfront (instead of CNAME)?"
  default     = false
}

variable "cloudfront_forward_headers" {
  default     = ["*"]
  description = "Headers to forward to origin from CloudFront"
}

variable "cloudfront_logging_bucket" {
  type        = string
  default     = ""
  description = "Bucket to store logs from app"
}

variable "cloudfront_logging_prefix" {
  type        = string
  default     = ""
  description = "Logging prefix"
}

variable "cloudfront_origin_keepalive_timeout" {
  default     = 5
  description = "The amount of time, in seconds, that CloudFront maintains an idle connection with a custom origin server before closing the connection. Valid values are from 1 to 60 seconds."
}

variable "cloudfront_origin_read_timeout" {
  default     = 30
  description = "The amount of time, in seconds, that CloudFront waits for a response from a custom origin. The value applies both to the time that CloudFront waits for an initial response and the time that CloudFront waits for each subsequent packet. Valid values are from 4 to 60 seconds."
}

variable "minimum_protocol_version" {
  description = <<EOF
    The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. 
    Can only be set if cloudfront_default_certificate = false. One of SSLv3, TLSv1, TLSv1_2016, 
    TLSv1.1_2016, TLSv1.2_2018 or TLSv1.2_2019. Default: TLSv1. NOTE: If you are using a custom 
    certificate (specified with acm_certificate_arn or iam_certificate_id), and have specified 
    sni-only in ssl_support_method, TLSv1 or later must be specified. If you have specified vip 
    in ssl_support_method, only SSLv3 or TLSv1 can be specified. If you have specified 
    cloudfront_default_certificate, TLSv1 must be specified.
    EOF

  type    = string
  default = "TLSv1.2_2019"
}

variable "restriction_type" {
  description = "The restriction type of your CloudFront distribution geolocation restriction. Options include none, whitelist, blacklist"
  type        = string
  default     = "none"
}

variable "restriction_location" {
  description = "The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist)"
  type        = list(any)
  default     = []
}

variable "cloudfront_web_acl_id" {
  default     = ""
  description = "Optional web acl (WAF) to attach to CloudFront"
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "Set the default file for the application"
}

variable "dynamic_custom_origin_config" {
  description = "Configuration for the custom origin config to be used in dynamic block"
  type        = any
  default     = []
}

variable "dynamic_ordered_cache_behavior" {
  description = "Ordered Cache Behaviors to be used in dynamic block"
  type        = any
  default     = []
}

variable "module_enabled" {
  description = "Enable the module to create resources"
  default     = true
}

variable "default_cache_behavior_forward_query_string" {
  default     = true
  description = "Default cache behavior forward"
}

variable "default_cache_behavior_forward_headers" {
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
  description = "Default cache behavior headers forward"
}

variable "default_cache_behavior_cookies_forward" {
  default     = "all"
  description = "Default cache behavior cookies forward"
}

variable "default_cache_behavior_allowed_methods" {
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  description = "Methods allowed for default origin cache behavior"
}

variable "wait_for_deployment" {
  default     = false
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed"
}

variable "response_page_path" {
  default     = "/index.html"
  description = "Custom error response page path"
}

variable "lambda_edge" {
  default     = []
  description = "Lambda EDGE configuration"
}

variable "default_threshold" {
  description = "The default threshold for the metric."
  default     = 5
}

variable "default_evaluation_periods" {
  description = "The default amount of evaluation periods."
  default     = 2
}

variable "default_period" {
  description = "The default evaluation period."
  default     = 60
}

variable "default_comparison_operator" {
  description = "The default comparison operator."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "default_statistic" {
  description = "The default statistic."
  default     = "Average"
}
variable "alarms" {
  type        = map(any)
  default     = {}
  description = <<EOF
The keys of the map are the metric names. This list must be given as a comma-separated string.
The following arguments are supported:
  - comparison_operator: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold
  - evaluation_periods: The number of periods over which data is compared to the specified threshold.
  - period: The period in seconds over which the specified statistic is applied.
  - statistic: The statistic to apply to the alarm's associated metric.
  - threshold: The number of occurances over a given period.
  - actions: The actions to execute when the alarm transitions into an ALARM state (ARN). 
  - ok_actions: The list of actions to execute when this alarm transitions into an OK state from any other state (ARN). 
EOF
}