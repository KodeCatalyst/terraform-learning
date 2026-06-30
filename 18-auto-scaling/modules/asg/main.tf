data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "main" {
    key_name   = "${var.environment}-asg-key"
    public_key = file(var.public_key_path)
}

resource "aws_security_group" "web" {
    name        = "${var.environment}-web-sg"
    description = "Allow traffic from the ALB only"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow traffic from the ALB only"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [var.alb_security_group_id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-web-sg"
        Environment = var.environment
    }
}

resource "aws_launch_template" "web" {
    name_prefix   = "${var.environment}-web-lt-"
    image_id      = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name      = aws_key_pair.main.key_name

    vpc_security_group_ids = [aws_security_group.web.id]

    user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install nginx1 -y
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>Welcome to ${var.environment} environment</h1>" > /var/www/html/index.html
            EOF
    )

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name        = "${var.environment}-web-server"
            Environment = var.environment
        }
    }

    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
    name                      = "${var.environment}-asg"
    vpc_zone_identifier       = var.private_subnet_ids
    target_group_arns         = [var.target_group_arn]

    min_size                  = var.min_size
    max_size                  = var.max_size
    desired_capacity          = var.desired_capacity

    health_check_type         = "ELB"
    health_check_grace_period = 60

    launch_template {
        id      = aws_launch_template.web.id
        version = "$Latest"
    }

    tag {
        key                 = "Name"
        value               = "${var.environment}-asg-instance"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "cpu_target_tracking" {
    name                   = "${var.environment}-cpu-target-tracking"
    autoscaling_group_name = aws_autoscaling_group.web.name
    policy_type            = "TargetTrackingScaling"

    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}