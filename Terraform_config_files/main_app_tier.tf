#App-tier launch template
resource "aws_launch_template" "apptier_template" {
  name                   = var.launch_template_names[0]
  instance_type          = var.instance_type
  image_id               = var.image_ids[0]
  vpc_security_group_ids = [aws_security_group.apptier_sg.id]

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


#App-tier ALb
resource "aws_lb" "internal_load_balancer" {
  name                       = var.alb-names[0]
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ALB_internal_sg.id]
  subnets                    = [aws_subnet.apptier1.id, aws_subnet.apptier2.id]
  enable_deletion_protection = false

}

#App-tier ALB target group
resource "aws_lb_target_group" "instance_target_apptier" {
  name        = var.alb-tg[0]
  target_type = "instance"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.terra.id

  health_check {
    enabled             = true
    interval            = 30
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/health"
    timeout             = 5
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

}


#App-tier ALB listener
resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = aws_lb.internal_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_target_apptier.arn
  }

}

#App-tier ASG
resource "aws_autoscaling_group" "apptier_ASG" {
  name                  = var.asg_name[0]
  vpc_zone_identifier   = [aws_subnet.apptier1.id, aws_subnet.apptier2.id]
  desired_capacity      = 1
  max_size              = 2
  min_size              = 1
  protect_from_scale_in = false
  health_check_type     = "ELB"
  target_group_arns     = [aws_lb_target_group.instance_target_apptier.arn]

  launch_template {
    id      = aws_launch_template.apptier_template.id
    version = "$Latest"

  }
  tag {
    key                 = "Name"
    value               = "App_layer_VM"
    propagate_at_launch = true
  }

}

#App-tier ASG Policy
resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.apptier_ASG.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }

}

#App-tier sns topic
resource "aws_sns_topic" "apptier_cpu_utilisation_updates" {
  name = var.sns_name[0]
}

#App-tier ASG notification to sns
resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [aws_autoscaling_group.apptier_ASG.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.apptier_cpu_utilisation_updates.arn

}

#App-tier sns subscription
resource "aws_sns_topic_subscription" "cpu_updates" {
  topic_arn = aws_sns_topic.apptier_cpu_utilisation_updates.arn
  protocol  = var.sns_protocol
  endpoint  = var.sns_endpoint

}