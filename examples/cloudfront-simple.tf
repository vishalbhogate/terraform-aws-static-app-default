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
  hosted_zone     = "learn.solutions"
  hostname_create = true
}
