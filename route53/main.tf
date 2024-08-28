# resource "aws_route53_record" "my_domain" {
#   zone_id = aws_route53_zone.my_zone.zone_id
#   name    = "arshu.xyz"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.my_distribution.domain_name
#     zone_id                = aws_cloudfront_distribution.my_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
