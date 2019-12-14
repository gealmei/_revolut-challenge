resource "aws_route53_zone" "private" {
  name = "default_tag.internal.uk"

  vpc {
    vpc_id = aws_vpc.default.id
  }
}

resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "5"
  records        = [aws_rds_cluster.postgresql.endpoint]
}
