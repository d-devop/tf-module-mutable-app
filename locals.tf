locals {
  vpc_id              = lookup(lookup(var.vpc, var.env, null), "vpc_id", null)
  app_subnets_cidr    = lookup(lookup(var.vpc, var.env, null), "app_subnets_cidr", null)
  public_subnets_cidr = lookup(lookup(var.vpc, var.env, null), "public_subnets_cidr", null)
  app_subnets_ids     = lookup(lookup(var.vpc, var.env, null), "app_subnets_ids", null)
  public_subnets_ids  = lookup(lookup(var.vpc, var.env, null), "public_subnets_ids", null)

  allow_app_access = var.component == "frontend" ? local.public_subnets_cidr : local.app_subnets_cidr


  alb_arn = { for k, v in var.load_balancers : k => lookup(v.alb, "arn", null) }
  arn     = var.component == "frontend" ? local.alb_arn["public"] : local.alb_arn["private"]

  alb_dns_name = { for k, v in var.load_balancers : k => lookup(v.alb, "dns_name", null) }
  dns_name     = var.component == "frontend" ? local.alb_dns_name["public"] : local.alb_dns_name["private"]
}
