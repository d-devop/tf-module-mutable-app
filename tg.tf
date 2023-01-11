resource "aws_lb_target_group" "tg" {
  name     = "${var.component}-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}
