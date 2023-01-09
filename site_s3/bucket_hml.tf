### Bucket S3 #####
resource "aws_s3_bucket" "site" {
  bucket = "${var.domain}"
  acl = "public-read"

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Id": "Policy1663162260738",
        "Statement": [
            {
                "Sid": "Stmt1663162256001",
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.domain}/*"
            }
        ]
    }

  EOF

  website {
      index_document = "index.html"
      error_document = "404.html"
  }
    tags = {
    "Name" = "Site"
  }
}
#### CloudFront ####
resource "aws_cloudfront_distribution" "tf" {
  origin {
    domain_name = "${var.domain}.s3-website.us-east-1.amazonaws.com"
    origin_id = "${var.domain}"

    custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress = true
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
  }
#### ROUTE53 #####  
}
resource "aws_route53_record" "root_domain" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cdn.hosted_zone_id}"
    evaluate_target_health = false
  }
