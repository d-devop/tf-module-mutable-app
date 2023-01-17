resource "aws_lb_target_group" "tg" {
  name     = "${var.component}-${var.env}"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    path                = "/health"
    timeout             = 4
  }
}
