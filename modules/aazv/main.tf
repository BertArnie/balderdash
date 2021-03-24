provider "aws" {
  alias = "zone_provider"
}

provider "aws" {
  alias = "vpc_provider"
}

locals {
  combinations = [
    for pair in setproduct(var.zone_ids, var.vpc_ids) : {
      zone_id = pair[0]
      vpc_id  = pair[1]
    }
  ]
}

locals {
  zv_map = {
    for x in local.combinations : "${x.zone_id}+${x.vpc_id}" => x
  }
}


resource "aws_route53_vpc_association_authorization" "x" {
  provider = aws.zone_provider
  for_each = local.zv_map
  zone_id  = each.value.zone_id
  vpc_id   = each.value.vpc_id
}

resource "aws_route53_zone_association" "x" {
  provider = aws.vpc_provider
  for_each = local.zv_map
  zone_id  = each.value.zone_id
  vpc_id   = each.value.vpc_id
}
