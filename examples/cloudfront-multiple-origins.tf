resource "aws_s3_bucket" "app_frontend" {
  bucket_prefix = "my-frontend-app-"
  acl           = "private"
}

module "app_frontend" {
  source = "../" # Always check the latest version

  name            = "my-frontend-app"
  s3_bucket_id    = aws_s3_bucket.app_frontend.id
  hostnames       = ["test.learn.solutions"]
  certificate_arn = data.aws_acm_certificate.domain_host_us.arn
  hosted_zone     = "test.solutions"
  hostname_create = true
  dynamic_custom_origin_config = [
    {
      domain_name              = "my-app-origin.test.solutions"
      origin_id                = "my-app-origin"
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_protocol_policy   = "https-only"
      origin_ssl_protocols     = ["TLSv1.2", "TLSv1.1"]
      custom_header = [
        {
          name  = "Test1"
          value = "Test1-Header"
        },
        {
          name  = "Test2"
          value = "Test2-Header"
        }
      ]
    }
  ]
  dynamic_ordered_cache_behavior = [{
    path_pattern           = "path/test*",
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"],
    cached_methods         = ["GET", "HEAD"],
    target_origin_id       = "my-app-origin",
    compress               = false,
    query_string           = true,
    cookies_forward        = "all",
    headers                = ["Accept", "Authorization", "Origin"],
    viewer_protocol_policy = "redirect-to-https",
    min_ttl                = 0,
    default_ttl            = 0,
    max_ttl                = 0,
    lambda_function_association = [{
      event_type   = "origin-request",
      lambda_arn   = "arn:aws:lambda:us-east-1:xxxxxxxxx:function:test-lambda-edge:1",
      include_body = false
    }]
  }]
}
