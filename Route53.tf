resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "aws_route53_record" "nginx_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "nginx.example.com"
  type    = "A"
  ttl     = 300
  records = [aws_nat_gateway.nat.public_ip]
}
