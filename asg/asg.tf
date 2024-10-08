module "sg" {
  source = "../sg"  # caminho correto para o módulo SG
}
module "vpc" {
  source = "../vpc"  # caminho correto para o módulo VPC
}


resource "aws_launch_template" "web_server_lt" {
  name_prefix   = "web-server-"
  image_id      = "ami-003932de22c285676" # ubuntu 20.04
  instance_type = "t2.micro"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [module.sg.sg_public_ec2_id]
  }
}


# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity         = 1
  max_size                 = 2
  min_size                 = 1
  health_check_type        = "EC2"
  health_check_grace_period = 300

  vpc_zone_identifier      = [module.vpc.subnet_public_id] 

  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

}


resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
}