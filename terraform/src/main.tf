terraform {
  required_version = "1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "dns_production" {
  source = "./modules/dns"
  settings = {
    domain = "tumelo.com"
    tags = {
      environment = "production"
      managed_by  = "terraform"
    }
    records = {
      "statuspage.tumelo.com" = {
        type    = "CNAME"
        ttl     = 300
        records = ["statuspage-production-987654321.eu-west-2.elb.amazonaws.com"]
      }
      "api.tumelo.com" = {
        type    = "CNAME"
        ttl     = 300
        records = ["api-production-987654321.eu-west-2.elb.amazonaws.com"]
      }
      "app.tumelo.com" = {
        type = "A"
        alias = [
          {
            name                   = "9a8b7c654321a0.cloudfront.net"
            zone_id                = "1234567890ABCD"
            evaluate_target_health = true
          }
        ]
      }
      "tumelo.com" = {
        type    = "TXT"
        ttl     = 300
        records = ["domain-verification=qoqj3dJ5oIHEj7e9SOei2PKGxAVIUCCmnEzT7IfB"]
      }
    }
  }
}

module "dns_staging" {
  source = "./modules/dns"
  settings = {
    domain = "tumelo-staging.com"
    tags = {
      environment = "staging"
      managed_by  = "terraform"
    }
    records = {
      "statuspage.tumelo-staging.com" = {
        type    = "CNAME"
        ttl     = 300
        records = ["statuspage-staging-123456789.eu-west-2.elb.amazonaws.com"]
      }
      "api.tumelo-staging.com" = {
        type    = "CNAME"
        ttl     = 300
        records = ["api-staging-123456789.eu-west-2.elb.amazonaws.com"]
      }
      "app.tumelo-staging.com" = {
        type = "A"
        alias = [
          {
            name                   = "a1b2c3d4056789.cloudfront.net"
            zone_id                = "ABCD1234567890"
            evaluate_target_health = true
          }
        ]
      }
    }
  }
}
