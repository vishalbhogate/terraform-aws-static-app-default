resource "aws_cloudfront_origin_access_identity" "default" {
  count   = var.module_enabled ? 1 : 0
  comment = "${var.name}-s3"
}

resource "aws_cloudfront_distribution" "default" {
  count = var.module_enabled ? 1 : 0

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.name
  aliases             = var.hostnames
  price_class         = "PriceClass_All"
  default_root_object = var.default_root_object
  wait_for_deployment = var.wait_for_deployment

  origin {
    domain_name = data.aws_s3_bucket.selected[0].bucket_regional_domain_name
    origin_id   = "s3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default[0].cloudfront_access_identity_path
    }
  }

  dynamic "origin" {
    for_each = [for i in var.dynamic_custom_origin_config : {
      domain_name              = i.domain_name
      origin_id                = i.origin_id != "" ? i.origin_id : "default"
      path                     = lookup(i, "origin_path", null)
      http_port                = i.http_port != "" ? i.http_port : 80
      https_port               = i.https_port != "" ? i.https_port : 443
      origin_protocol_policy   = i.origin_protocol_policy != "" ? i.origin_protocol_policy : "https-only"
      origin_read_timeout      = i.origin_read_timeout
      origin_keepalive_timeout = i.origin_keepalive_timeout
      origin_ssl_protocols     = lookup(i, "origin_ssl_protocols", ["SSLv3", "TLSv1.1", "TLSv1.2", "TLSv1"])
      custom_header            = lookup(i, "custom_header", null)
    }]

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.path

      dynamic "custom_header" {
        for_each = origin.value.custom_header == null ? [] : [for i in origin.value.custom_header : {
          name  = i.name
          value = i.value
        }]
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      custom_origin_config {
        http_port                = origin.value.http_port
        https_port               = origin.value.https_port
        origin_keepalive_timeout = origin.value.origin_keepalive_timeout
        origin_read_timeout      = origin.value.origin_read_timeout
        origin_protocol_policy   = origin.value.origin_protocol_policy
        origin_ssl_protocols     = origin.value.origin_ssl_protocols
      }
    }
  }

  dynamic "logging_config" {
    for_each = compact([var.cloudfront_logging_bucket])

    content {
      include_cookies = false
      bucket          = var.cloudfront_logging_bucket
      prefix          = var.cloudfront_logging_prefix
    }
  }

  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior_allowed_methods
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3Origin"
    compress         = true

    forwarded_values {
      query_string = var.default_cache_behavior_forward_query_string
      headers      = var.default_cache_behavior_forward_headers
      cookies {
        forward = var.default_cache_behavior_cookies_forward
      }
    }

    dynamic "lambda_function_association" {
      for_each = [for i in var.lambda_edge : {
        origin_request = i.origin_request
        include_body   = i.include_body
        lambda_arn     = i.lambda_arn
      }]
      content {
        event_type   = lambda_function_association.value.origin_request
        include_body = lambda_function_association.value.include_body
        lambda_arn   = lambda_function_association.value.lambda_arn
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.dynamic_ordered_cache_behavior
    iterator = cache_behavior

    content {
      path_pattern     = cache_behavior.value.path_pattern
      allowed_methods  = cache_behavior.value.allowed_methods
      cached_methods   = cache_behavior.value.cached_methods
      target_origin_id = cache_behavior.value.target_origin_id
      compress         = lookup(cache_behavior.value, "compress", null)
      cache_policy_id  = lookup(cache_behavior.value, "cache_policy_id", null)

      dynamic "forwarded_values" {
        iterator = fwd
        for_each = lookup(cache_behavior.value, "use_forwarded_values", [])
        content {
          query_string = lookup(fwd.value, "query_string", null)
          headers      = lookup(fwd.value, "headers", null)
          cookies {
            forward = lookup(fwd.value, "cookies_forward", null)
          }
        }
      }

      dynamic "lambda_function_association" {
        iterator = lambda
        for_each = lookup(cache_behavior.value, "lambda_function_association", [])
        content {
          event_type   = lambda.value.event_type
          lambda_arn   = lambda.value.lambda_arn
          include_body = lookup(lambda.value, "include_body", null)
        }
      }

      viewer_protocol_policy = cache_behavior.value.viewer_protocol_policy
      min_ttl                = lookup(cache_behavior.value, "min_ttl", null)
      default_ttl            = lookup(cache_behavior.value, "default_ttl", null)
      max_ttl                = lookup(cache_behavior.value, "max_ttl", null)
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.minimum_protocol_version
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.restriction_location
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = var.response_page_path
  }

  web_acl_id = var.cloudfront_web_acl_id != "" ? var.cloudfront_web_acl_id : ""
}
