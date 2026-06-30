// Alb security group
resource "aws_security_group" "alb" {
    name = "${var.environment}-alb-sg"
    description = "Allow HTTP traffic to ALB"
    vpc_id = var.vpc_id

    ingress {
        description = "HTTP from internet"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.environment}-alb-sg"
        Environment = var.environment
    }
}

// Target group
resource "aws_lb_target_group" "main" {
    name     = "${var.environment}-tg"
    port    = 80
    protocol = "HTTP"
    vpc_id  = var.vpc_id

    health_check {
        enabled            = true
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 3
        matcher             = "200"
    }

    tags = {
        Name = "${var.environment}-tg"
        Environment = var.environment
    }
}

// Application Load Balancer
resource "aws_lb" "main" {
    name               = "${var.environment}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = var.public_subnet_ids

    tags = {
        Name = "${var.environment}-alb"
        Environment = var.environment
    }
}

resource "aws_alb_listener" "http"{
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.main.arn
    }
}