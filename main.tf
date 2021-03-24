terraform {
  required_version = ">= 0.14.8"
  required_providers {
    aws = ">= 3.32.0"
  }
}

provider "aws" {
  alias = "accountA"
  assume_role {
    role_arn = "arn:aws:iam::123456789098:role/rolename"
  }
}

provider "aws" {
  alias = "accountB"
  assume_role {
    role_arn = "arn:aws:iam::987654321012:role/rolename"
  }
}

module "one" {
  source = "./modules/aazv"
  providers = {
    aws.zone_provider = aws.accountA
    aws.vpc_provider  = aws.accountB
  }
  # zone_id = "Your zone ID here"
  zone_ids = [aws_route53_zone.target.zone_id]
  vpc_ids = [
    # Your vpcs here
    "vpc-0cac04ffc6e165683",
    "vpc-09e853c653b28cc4b",
  ]
}

resource "aws_route53_zone" "target" {
  provider = aws.accountA
  name     = "balderdash"

  vpc {
    vpc_id = "vpc-0b87a84cb9496985a"
  }

  lifecycle {
    ignore_changes = [
      vpc,
    ]
  }
}

resource "aws_route53_record" "bob" {
  provider = aws.accountA
  zone_id  = aws_route53_zone.target.zone_id
  name     = "bob.${aws_route53_zone.target.name}"
  type     = "TXT"
  ttl      = "300"
  records  = ["pizza"]
}

