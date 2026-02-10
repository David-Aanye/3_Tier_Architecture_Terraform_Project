#Web-tier launch template
resource "aws_launch_template" "webtier_template" {
  name          = var.launch_template_names[1]
  instance_type = var.instance_type
  image_id      = var.image_ids[1]

  network_interfaces {
    security_groups = [aws_security_group.webtier_sg.id]
    associate_public_ip_address = true

  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 10
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

}

#Web-tier ALb
resource "aws_lb" "external_load_balancer" {
  name                       = var.alb-names[1]
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ALB_external_sg.id]
  subnets                    = [aws_subnet.webtier1.id, aws_subnet.webtier2.id]
  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "ACL"
  }

}

#Web-tier ALB target group
resource "aws_lb_target_group" "instance_target_webtier" {
  name        = var.alb-tg[1]
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terra.id

  health_check {
    enabled             = true
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

#Web-tier ALB listener
resource "aws_lb_listener" "elb_listener_web" {
  load_balancer_arn = aws_lb.external_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_target_webtier.arn
  }

}

#Web-tier
resource "aws_autoscaling_group" "webtier_ASG" {
  name                  = var.asg_name[1]
  vpc_zone_identifier   = [aws_subnet.webtier1.id, aws_subnet.webtier2.id]
  desired_capacity      = 1
  max_size              = 2
  min_size              = 1
  protect_from_scale_in = false
  health_check_type     = "ELB"
  target_group_arns     = [aws_lb_target_group.instance_target_webtier.arn]


  launch_template {
    id      = aws_launch_template.webtier_template.id
    version = "$Latest"

  }

  tag {
    key                 = "Name"
    value               = "Web_layer_VM"
    propagate_at_launch = true
  }

}

#Web-tier ASG policy
resource "aws_autoscaling_policy" "alb-request-count-per-target" {
  name                   = "cpu-scaling-metric"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.webtier_ASG.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}

#Webtier sns topic
resource "aws_sns_topic" "webtier_cpu_utilisation_updates" {
  name = var.sns_name[1]
}

resource "aws_autoscaling_notification" "web_example_notifications" {
  group_names = [aws_autoscaling_group.webtier_ASG.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.webtier_cpu_utilisation_updates.arn
}

resource "aws_sns_topic_subscription" "web_cpu_updates" {
  topic_arn = aws_sns_topic.webtier_cpu_utilisation_updates.arn
  protocol  = var.sns_protocol
  endpoint  = var.sns_endpoint

}