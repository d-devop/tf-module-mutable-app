resource "aws_spot_instance_request" "rabbitmq" {
  count                  = var.instance_count
  ami                    = data.aws_ami.centos8.id
  instance_type          = var.instance_type
  subnet_id              = element(local.app_subnets_ids, count.index)
  vpc_security_group_ids = [aws_security_group.allow_app.id]
  wait_for_fulfillment   = true

  tags = {
    Name = "${var.env}-rabbitmq"
  }

  user_data = <<EOF
#!/bin/bash
touch /opt/user-data.log
id >>/opt/user-data.log
labauto ansible
ansible-pull -i localhost, -U https://github.com/d-devop/roboshop-ansible roboshop.yml -e ROLE_NAME=rabbitmq -e ENV=${var.env} | tee -a /opt/user-data.log
EOF
}

resource "aws_ec2_tag" "name-tag" {
  count                  = var.instance_count
  resource_id = element(aws_spot_instance_request.rabbitmq.*.spot_instance_id, count.index)
  key         = "Name"
  value       = "${var.env}-rabbitmq"
}