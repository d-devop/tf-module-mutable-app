resource "aws_launch_template" "launch-template" {
  name_prefix            = "${var.component}-${var.env}"
  image_id               = data.aws_ami.centos8.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_app.id]

  instance_market_options {
    market_type = "spot"
  }

  user_data = base64encode(templatefile("${path.module}/ansible-pull.sh", {
    component = var.component
    env       = var.env
  }))
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.component}-${var.env}"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = local.app_subnets_ids

  target_group_arns = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.component}-${var.env}"
    propagate_at_launch = true
  }

}
