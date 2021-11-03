data "aws_s3_bucket" "selected" {
  count = var.module_enabled ? 1 : 0

  bucket = var.s3_bucket_id
}
