resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "my-load-balancer"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "my-load-balancer"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_route53_zone" "my_zone" {
  name = "arshu.xyz"
}

resource "aws_route53_record" "my_domain" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "arshu.xyz"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2"  # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}
