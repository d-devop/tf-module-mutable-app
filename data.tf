data "aws_ami" "centos8" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}
