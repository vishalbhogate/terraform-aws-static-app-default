data "aws_route53_zone" "selected" {
  count = var.hostname_create && var.module_enabled ? 1 : 0
  name  = var.hosted_zone
}

resource "aws_route53_record" "hostname" {
  count = var.hostname_create && var.module_enabled && var.hostname_alias == false ? length(var.hostnames) : 0

  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.hostnames[count.index]
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.default[0].domain_name]
}

resource "aws_route53_record" "hostname_alias" {
  count = var.hostname_create && var.module_enabled && var.hostname_alias == true ? length(var.hostnames) : 0

  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = var.hostnames[count.index]
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.default[0].domain_name
    zone_id                = aws_cloudfront_distribution.default[0].hosted_zone_id
    evaluate_target_health = true
  }
}
