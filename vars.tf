variable "env" {}
variable "instance_type" {}
variable "vpc" {}
variable "component" {}
variable "allow_ssh_cidr" {}

variable "desired_capacity" {}
variable "max_size" {}
variable "min_size" {}
variable "app_port" {}
variable "load_balancers" {}
variable "lb_rule_priority" {}
variable "domain" {}
variable "allow_monitor_cidr" {}
variable "acm_cert_arn" {}