resource "aws_lb_listener" "listener_public" {
  count             = var.component == "frontend" ? 1 : 0
  load_balancer_arn = local.arn
  port              = "80"
  protocol          = "HTTP"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "listener_private" {
  count             = var.component == "frontend" ? 0 : 1
  load_balancer_arn = local.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "static" {
  count        = var.component == "frontend" ? 0 : 1
  listener_arn = aws_lb_listener.listener_private.*.arn[0]
  priority     = var.lb_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }


  condition {
    host_header {
      values = ["${var.env}-${var.component}.${var.domain}"]
    }
  }
}
