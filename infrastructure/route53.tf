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

resource "aws_route53_zone" "public" {
  name = "revolut-guilherme.co.uk"
}

resource "aws_route53_record" "host-A" {
  zone_id = aws_route53_zone.public.zone_id
  name = "bastion"
  type = "A"
  records = [aws_instance.ec2.public_ip]
  ttl = "5"
}
