module "sg"{
    source = "../sg"
}

module "vpc"{
    source = "../vpc"
}

resource "aws_lb" "load_balancer_mcc2_nvc" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg.sg_alb_id]  
  subnets            = [module.vpc.subnet_public_id]

  enable_deletion_protection = false

  tags = {
    Name = "my-app-lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.aws_vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
  }

  tags = {
    Name = "my-target-group"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_id = aws_autoscaling_group.web_asg.id
  target_group_arn     = aws_lb_target_group.target_group.arn
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer_mcc2_nvc.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}