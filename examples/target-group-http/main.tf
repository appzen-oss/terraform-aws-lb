# Create VPC and everything for test

module "vpc" {
  source     = "cloudposse/vpc/aws"
  version    = "0.3.5"
  namespace  = "${var.organization}"
  stage      = "dev"
  name       = "${var.environment}"
  cidr_block = "${var.vpc_cidr}"
  tags       = "${map("Environment", "${var.environment}")}"
}

locals {
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "dynamic_subnets" {
  #source             = "cloudposse/dynamic-subnets/aws"
  #version            = "0.3.8"
  source = "git::https://github.com/appzen-oss/terraform-aws-dynamic-subnets.git?ref=master"

  namespace          = "${var.organization}"
  stage              = "dev"
  name               = "${var.environment}"
  region             = "${var.region}"
  availability_zones = ["${local.availability_zones}"]
  vpc_id             = "${module.vpc.vpc_id}"
  igw_id             = "${module.vpc.igw_id}"
  cidr_block         = "${module.vpc.vpc_cidr_block}"
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = "${module.vpc.vpc_id}"

  tags {
    Network = "Private"
  }
}

# Create SG
resource "aws_security_group" "lb" {
  name        = "testing_lb"
  description = "For testing LB Terraform module"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "lb-http" {
  source       = "../../"
  name         = "lb-http"
  environment  = "${var.environment}"
  organization = "${var.organization}"

  enabled           = false
  target_group_only = true

  #enable_deletion_protection = true
  #enable_http2         = false
  instance_http_ports = "80,8080"

  instance_https_ports = ""
  instance_tcp_ports   = ""
  lb_http_ports        = "80,8080"
  lb_https_ports       = ""
  lb_protocols         = ["HTTP"]
  lb_tcp_ports         = ""
  ports                = "3000,4000"
  security_groups      = ["${aws_security_group.lb.id}"]                 # Need at least 1
  subnets              = "${data.aws_subnet_ids.private_subnet_ids.ids}"
  vpc_id               = "${module.vpc.vpc_id}"
}
