terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_route53_zone" "this" {
  name = "tumelo-staging.com"
  tags = {
    environment = "staging"
    managed_by  = "terraform"
  }
}

resource "aws_route53_record" "statuspage" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "statuspage.tumelo-staging.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["statuspage-staging-123456789.eu-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "api.tumelo-staging.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["api-staging-123456789.eu-west-2.elb.amazonaws.com"]
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "app.tumelo-staging.com"
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = "a1b2c3d4056789.cloudfront.net"
    zone_id                = "ABCD1234567890"
  }
}
