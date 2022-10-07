provider "aws" {
  region     = "ap-south-1"
}

terraform{
  backend "s3"{}
}

data "aws_caller_identity" "current"{}

data "aws_region" "current"{}

data "aws_ssm_parameter" "vpc_name"{
  name=""
}

data "aws_ssm_parameter" "s3_bucket_name"{
  name=""
}

data "aws_ssm_parameter" "vpc_id"{
  name=""
}

data "aws_ssm_parameter" "private_subnets"{
  name=""
}

data "aws_ssm_parameter" "instance_type"{
  name=""
}

data "aws_ssm_parameter" "instance_profile_arn"{
  name=""
}

data "aws_ssm_parameter" "desired_capacity"{
  name=""
}

data "aws_ssm_parameter" "max_size"{
  name=""
}

data "aws_ssm_parameter" "min_size"{
  name=""
}

data "aws_ssm_parameter" "default_cooldown"{
  name=""
}

data "aws_ssm_parameter" "health_check_grace_period"{
  name=""
}

data "aws_ssm_parameter" "health_check_type"{
  name=""
}

data "aws_ssm_parameter" "private_zone_id"{
  name=""
}

data "aws_ssm_parameter" "hostedzone"{
  name=""
}

data "aws_ssm_parameter" "key_name"{
  name=""
}

data "aws_ssm_parameter" "config_file"{
  name=""
}

# 
data "aws_ssm_parameter" "EMPLOYEE_APP_ACCESS_TOKEN"{
  name=""
}

# 
data "aws_ssm_parameter" "EMPLOYEE_JDBC_REPO_ID"{
  name=""
}

# 
data "aws_ssm_parameter" "EMPLOYEE_JDBC_ENV_ID"{
  name=""
}

data "aws_vpc" "by_name"{
  filter {
    name= "tag:name"
    values = ["${data.aws_ssm_parameter.vpc_name.value}"]
  }
}

data "template_file" "user_data"{
  template = "${file("${path.module}/launch-template.sh")}"
  vars={
    ENVIRONMENT_NAME="${lower(var.environment)}"
    S3_Bucket_Name=data.aws_ssm_parameter.s3bucketname.value
    Account_ID="${data.aws_caller_identity.current.account_id}"
    EMPLOYEE_APP_ACCESS_TOKEN="${data.aws_ssm_parameter.EMPLOYEE_APP_ACCESS_TOKEN.value}"
    EMPLOYEE_JDBC_REPO="${data.aws_ssm_parameter.EMPLOYEE_JDBC_REPO_ID.value}"
    EMPLOYEE_JDBC_ENV_ID="${data.aws_ssm_parameter.EMPLOYEE_JDBC_ENV_ID.value}"
  }
}

resource "aws_security_group" "EMPLOYEE_JDBC_ASG_SG" {
  name= "${var.name}-SG-${var.environment}"
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  tags=merge(var.tags,var.default_tags)
}

# ingress security inbound rule
resource "aws_security_group" "sg_inbound_rule_2" {
  from_port = 60000
  protocol= "tcp"
  security_group_id = aws_security_group.EMPLOYEE_JDBC_ASG_SG.id
  to_port=60000
  type="ingress"
  cidr_blocks=["10.0.0.0/8"]
}


resource "aws_security_group" "sg_inbound_rule_3" {
  from_port = 60001
  protocol= "tcp"
  security_group_id = aws_security_group.EMPLOYEE_JDBC_ASG_SG.id
  to_port=60001
  type="ingress"
  cidr_blocks=["10.0.0.0/8"]
}

resource "aws_security_group" "sg_inbound_rule_4" {
  from_port = 9100
  protocol= "tcp"
  security_group_id = aws_security_group.EMPLOYEE_JDBC_ASG_SG.id
  to_port=9100
  type="ingress"
  cidr_blocks=["10.0.0.0/8"]
}

resource "aws_security_group" "sg_inbound_rule_5" {
  from_port = 8080
  protocol= "tcp"
  security_group_id = aws_security_group.EMPLOYEE_JDBC_ASG_SG.id
  to_port=8080
  type="ingress"
  cidr_blocks=["10.0.0.0/8"]
}

# All OutBound Access
resource "aws_security_group" "sg_inbound_rule_5" {
  from_port = 0
  protocol= "All"
  security_group_id = aws_security_group.EMPLOYEE_JDBC_ASG_SG.id
  to_port=65535
  type="egress"
  cidr_blocks=["0.0.0.0/0"]
}

# -----------------------------------------------------
# network load balancer and target group with 443 port listener
# -------------------------------------------------

resource "aws_alb" "EMPLOYEE_JDBC_ALB" {
  name="${var.name}-LB-${var.environment}"
  internal=true
  load_balancer_type="network"
  subnets="${split(",",data.aws_ssm_parameter.private_subnets.value)}"
  enable_deletion_protection = true

  tags=merge(var.tags,var.default_tags)
}

resource "aws_lb_target_group" "EMPLOYEE_TRAGET_GROUP" {
  name="${var.name}-TG-${var.environment}"
  port=60000
  protocol = "TCP"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  tags=merge(var.tags,var.default_tags)
  health_check {
    port="traffic-port"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 10
    interval = 30
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "EMPLOYEE_JDBC_Attach" {
  load_balancer_arn = aws_alb.EMPLOYEE_JDBC_ALB.arn
  port="60000"
  protocol = "TCP"
  default_action{
    type ="forward"
    target_group_arn = aws_lb_target_group.EMPLOYEE_TRAGET_GROUP.arn
  }
}

# ---------------------------------
# attaching launch template for Autoscaling group for managing ec2 instance
# -----------------------------

resource "aws_launch_template" "EMPLOYEE_JDBC_LAUNCH_TEMPLATE" {
  name_prefix="${var.name}-LT-${var.environment}"
  image_id = data.aws_ssm_parameter.image_id.value
  instance_type = data.aws_ssm_parameter.instance_type.value
  description = var.description
  iam_instance_profile {
    arn=data.aws_ssm_parameter.instance_profile_arn.value
  }
  network_interfaces {
    security_groups = [aws_security_group.EMPLOYEE_JDBC_ASG_SG.id]
    # vpc_security_group_ids=["${aws_security_group.EMPLOYEE_JDBC_ASG_SG.id}"]
    delete_on_termination = "true"
  }
  block_device_mappings {
    device_name="/dev/sda1"
    ebs{
      volume_size=20
      volume_type="gp2"
      encrypted="true"
      delete_on_termination = "true"
    }
  }
  key_name = data.aws_ssm_parameter.key_name.value
  tags=merge(var.tags,var.default_tags)
  user_data = base64encode("${data.template_file.user_data.rendered}")
  lifecycle {
    create_before_destroy = true
  }
}
# ----------------------------------------------------
# ngnix Autoscaling Group and Attaching with Target group
# ---------------------------------------------

resource "aws_autoscaling_group" "EMPLOYEE_JDBC_ASG" {
 name_prefix="${var.name}-ASG-${var.environment}"
 vpc_zone_identifier = "${split(",",data.aws_ssm_parameter.private_subnets.value)}"
 desired_capacity = data.aws_ssm_parameter.desired_capacity.value
 max_size = data.aws_ssm_parameter.max_size.value
 min_size = data.aws_ssm_parameter.min_size.value
 default_cooldown = data.aws_ssm_parameter.default_cooldown.value
 health_check_grace_period = data.aws_ssm_parameter.health_check_grace_period.value
 health_check_type = data.aws_ssm_parameter.health_check_type.value
 launch_template {
   id=aws_launch_template.EMPLOYEE_JDBC_LAUNCH_TEMPLATE.id
   version="$Latest"
 }
 dynamic "tag"{
  for_each=merge(var.tags,var.default_tags)
  content{
    key=tag.key
    value=tag.value
    propagate_at_launch=true
  }
 }
 lifecycle {
   ignore_changes = [
    load_balancers, target_group_arns 
   ]
 }
}

resource "aws_autoscaling_attachment" "asg_attachment_with_EMPLOYEE_TARGET_GROUP" {
  autoscaling_group_name = aws_autoscaling_group.EMPLOYEE_JDBC_ASG.id
  alb_target_group_arn = aws_lb_target_group.EMPLOYEE_TRAGET_GROUP.arn
}

# -------------------------
# SNS for ASG Notifications
# ------------------------
resource "aws_sns_topic" "EMPLOYEE_JDBC_SNS" {
  name="${var.name}-SNS-${var.environment}"
  tags=merge(var.tags,var.default_tags)
}

resource "aws_autoscaling_notification" "EMPLOYEE_JDBC_ASG_Notification" {
  group_names = ["${aws_autoscaling_group.EMPLOYEE_JDBC_ASG.name}"]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = aws_sns_topic.EMPLOYEE_JDBC_SNS.arn
}

# ------------------------------------------------
# create a RecordSet/ALiasDomainName TO Route Traffic Across The Autoscaling group and Route53 recordsets
# ------------------------

resource "aws_route53_record" "EMPLOYEE_JDBC_aliasDNS" {
  zone_id = data.aws_ssm_parameter.private_zone_id.value
  name="${var.name}.${var.environment}.${data.aws_ssm_parameter.hostedzone.value}"
  type="CNAME"
  ttl="60"
  records = ["${aws_alb.EMPLOYEE_JDBC_ALB.dns_name}"]
}

# create AWS code_deploy configurations

resource "aws_iam_role" "EMPLOYEE_JDBC_IAM_ROLE" {
  name="${var.name}-CodeeDeployROle-${var.environment}"
  
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement" : [
    {
      "Sid": "",
      "Effect" : "Allow",
      "Principal" : {
        "Service": "codedeploy.amazonaws.com"
      },
        
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "AWSCodedeployRole" {
  policy_arn = "arn:aws:"
}