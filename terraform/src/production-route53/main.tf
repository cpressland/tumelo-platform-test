terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_route53_zone" "this" {
  name = "tumelo.com"
  tags = {
    environment = "production"
    managed_by  = "terraform"
  }
}

resource "aws_route53_record" "statuspage" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "statuspage.tumelo.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["statuspage-production-987654321.eu-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "api.tumelo.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["api-production-987654321.eu-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "app.tumelo.com"
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = "9a8b7c654321a0.cloudfront.net"
    zone_id                = "1234567890ABCD"
  }
}

resource "aws_route53_record" "sso" {
  zone_id = aws_route53_zone.this.zone_id
  type    = "TXT"
  name    = "tumelo.com"
  records = ["domain-verification=qoqj3dJ5oIHEj7e9SOei2PKGxAVIUCCmnEzT7IfB"]
  ttl     = "300"
}
