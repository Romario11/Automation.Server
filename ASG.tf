data "aws_key_pair" "test_keys" {
  key_name = "test_keys"
  tags = {
    "Name"    = "WEB server key",
    "Project" = var.project_name
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  tags = {
    "Name"    = "WEB server ami",
    "Project "= var.project_name
  }
}



resource "aws_launch_configuration" "web-servers" {
  name_prefix = "web-"
  image_id = data.aws_ami.amazon-linux-2.id
  instance_type = var.server_instance
  key_name = data.aws_key_pair.test_keys.key_name
  security_groups = [ aws_security_group.web_server_firewall.id ]
  associate_public_ip_address = false
  user_data = file("start_script.sh")
  iam_instance_profile = aws_iam_instance_profile.web_server_instance_profile.id
  depends_on = [aws_s3_object.my_web_site_objects_dirs,aws_s3_bucket.my_site_bucket]
}


resource "aws_autoscaling_group" "auto_scaling" {
  name = "ASG"
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  target_group_arns = [aws_lb_target_group.alb_tg.arn]
  launch_configuration = aws_launch_configuration.web-servers.id
  vpc_zone_identifier  = [aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]
  default_cooldown = 20
  health_check_grace_period = 20

  tag {
    key                 = "Etag"
    value               = aws_s3_object.my_web_site_objects_dirs.etag
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}


resource "aws_security_group" "web_server_firewall" {
  vpc_id = aws_vpc.my_vpc.id
  name        = "web_server_firewall"
  description = "Allow inbound traffic for web_server_firewall"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    "Name" = "Web server firewall",
    "Project" = var.project_name
  }
}


/*resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.example.name
  alb_target_group_arn = aws_lb_target_group.alb_tg.arn
}*/

/*
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web-servers.name}-asg"
  min_size             = 1
  desired_capacity     = 2
  max_size             = 3

  health_check_type    = "ELB"
  load_balancers = [ aws_lb.public_alb.arn]
  launch_configuration = aws_launch_configuration.web-servers.id
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier  = [
    aws_subnet.private_subnet.id,aws_subnet.private_subnet1.id
  ]
  # Required to redeploy without an outage.
depends_on = [aws_lb.public_alb]

}*/
