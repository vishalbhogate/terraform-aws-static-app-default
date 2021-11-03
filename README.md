# terraform-aws-static-app

This is a module that creates a static application with a OAI Cloudfront.

The following resources will be created:
 - A bucket to store logs from app
 - An Amazon CloudFront origin access identity
 - Enable an optional web acl (WAF) to attach to CloudFront
 - A hostname in the hosted zone passed
 - AWS Identity and Access Management (IAM) policy for the S3 Bucket

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarms | The keys of the map are the metric names. This list must be given as a comma-separated string.<br>The following arguments are supported:<br>  - comparison\_operator: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold<br>  - evaluation\_periods: The number of periods over which data is compared to the specified threshold.<br>  - period: The period in seconds over which the specified statistic is applied.<br>  - statistic: The statistic to apply to the alarm's associated metric.<br>  - threshold: The number of occurances over a given period.<br>  - actions: The actions to execute when the alarm transitions into an ALARM state (ARN). <br>  - ok\_actions: The list of actions to execute when this alarm transitions into an OK state from any other state (ARN). | `map(any)` | `{}` | no |
| certificate\_arn | n/a | `any` | n/a | yes |
| cloudfront\_forward\_headers | Headers to forward to origin from CloudFront | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| cloudfront\_logging\_bucket | Bucket to store logs from app | `string` | `""` | no |
| cloudfront\_logging\_prefix | Logging prefix | `string` | `""` | no |
| cloudfront\_origin\_keepalive\_timeout | The amount of time, in seconds, that CloudFront maintains an idle connection with a custom origin server before closing the connection. Valid values are from 1 to 60 seconds. | `number` | `5` | no |
| cloudfront\_origin\_read\_timeout | The amount of time, in seconds, that CloudFront waits for a response from a custom origin. The value applies both to the time that CloudFront waits for an initial response and the time that CloudFront waits for each subsequent packet. Valid values are from 4 to 60 seconds. | `number` | `30` | no |
| cloudfront\_web\_acl\_id | Optional web acl (WAF) to attach to CloudFront | `string` | `""` | no |
| default\_cache\_behavior\_allowed\_methods | Methods allowed for default origin cache behavior | `list` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "OPTIONS",<br>  "PATCH",<br>  "POST",<br>  "PUT"<br>]</pre> | no |
| default\_cache\_behavior\_cookies\_forward | Default cache behavior cookies forward | `string` | `"all"` | no |
| default\_cache\_behavior\_forward\_headers | Default cache behavior headers forward | `list` | <pre>[<br>  "Access-Control-Request-Headers",<br>  "Access-Control-Request-Method",<br>  "Origin"<br>]</pre> | no |
| default\_cache\_behavior\_forward\_query\_string | Default cache behavior forward | `bool` | `true` | no |
| default\_comparison\_operator | The default comparison operator. | `string` | `"GreaterThanOrEqualToThreshold"` | no |
| default\_evaluation\_periods | The default amount of evaluation periods. | `number` | `2` | no |
| default\_period | The default evaluation period. | `number` | `60` | no |
| default\_root\_object | Set the default file for the application | `string` | `"index.html"` | no |
| default\_statistic | The default statistic. | `string` | `"Average"` | no |
| default\_threshold | The default threshold for the metric. | `number` | `5` | no |
| dynamic\_custom\_origin\_config | Configuration for the custom origin config to be used in dynamic block | `any` | `[]` | no |
| dynamic\_ordered\_cache\_behavior | Ordered Cache Behaviors to be used in dynamic block | `any` | `[]` | no |
| hosted\_zone | n/a | `any` | n/a | yes |
| hostname\_alias | Create an Alias host in route53 for Cloudfront (instead of CNAME)? | `bool` | `false` | no |
| hostname\_create | Create hostname in the hosted zone passed? | `bool` | `true` | no |
| hostnames | n/a | `list(string)` | n/a | yes |
| lambda\_edge | Lambda EDGE configuration | `list` | `[]` | no |
| minimum\_protocol\_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. <br>    Can only be set if cloudfront\_default\_certificate = false. One of SSLv3, TLSv1, TLSv1\_2016, <br>    TLSv1.1\_2016, TLSv1.2\_2018 or TLSv1.2\_2019. Default: TLSv1. NOTE: If you are using a custom <br>    certificate (specified with acm\_certificate\_arn or iam\_certificate\_id), and have specified <br>    sni-only in ssl\_support\_method, TLSv1 or later must be specified. If you have specified vip <br>    in ssl\_support\_method, only SSLv3 or TLSv1 can be specified. If you have specified <br>    cloudfront\_default\_certificate, TLSv1 must be specified. | `string` | `"TLSv1.2_2019"` | no |
| module\_enabled | Enable the module to create resources | `bool` | `true` | no |
| name | n/a | `any` | n/a | yes |
| response\_page\_path | Custom error response page path | `string` | `"/index.html"` | no |
| restriction\_location | The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist) | `list(any)` | `[]` | no |
| restriction\_type | The restriction type of your CloudFront distribution geolocation restriction. Options include none, whitelist, blacklist | `string` | `"none"` | no |
| s3\_bucket\_id | n/a | `any` | n/a | yes |
| wait\_for\_deployment | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| cf\_domain\_name | CloudFront Domain Name |

<!--- END_TF_DOCS --->

## Author
Module managed by [Vishal Bhogate](https://github.com/vishalbhogate).

