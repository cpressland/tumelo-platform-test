terraform {
  required_version = "1.7.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55.0"
    }
  }
}

variable "settings" {
  type = object({
    domain = string
    tags   = map(string)
    records = optional(map(object({
      type    = string
      ttl     = optional(number, null)
      records = optional(list(string), [])
      alias = optional(list(object({
        name                   = string
        zone_id                = string
        evaluate_target_health = bool
      })), [])
    })), {})
  })
  description = "Base settings for the DNS module"
}

resource "aws_route53_zone" "i" {
  name = var.settings.domain
  tags = var.settings.tags
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "i" {
  for_each = var.settings.records

  zone_id = aws_route53_zone.i.zone_id
  name    = each.key
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
