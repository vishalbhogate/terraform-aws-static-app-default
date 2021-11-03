resource "aws_s3_bucket" "app_frontend" {
  bucket_prefix = "my-frontend-app-"
  acl           = "private"
}

module "app_frontend" {
  source = "../" # Always check the latest version

  name            = "my-frontend-app"
  s3_bucket_id    = aws_s3_bucket.app_frontend.id
  hostnames       = ["www.example.com"]
  certificate_arn = "arn:aws:acm:us-east-1:<account-id>:certificate/<certificate-hash>" # Replace the <account-id> and <certificate-hash> from a valid certificate
  hosted_zone     = "example.com"
  hostname_create = true

  alarms = {
    "TotalErrorRate" = {
      threshold = 1 #(%)
    }
    "5xxErrorRate" = {
      threshold = 5 #(%)
    }
  }
}
