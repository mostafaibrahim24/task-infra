#generated key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "app_kp" {
  key_name   = "${var.infra_env}-app-kp"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./appinstances-kp.pem"
  file_permission = "0400"
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.infra_env}-ec2-sg"
  description = "Allow SSH + HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.infra_env}-ec2-sg"
  }
}

# RDS SG
resource "aws_security_group" "rds_sg" {
  name        = "${var.infra_env}-rds-sg"
  description = "Allow MySQL from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description              = "MySQL"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups =  [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.infra_env}-rds-sg"
  }
}

resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_kp.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.infra_env}-frontend"
  }
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_kp.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.infra_env}-backend"
  }
}


resource "aws_sns_topic" "cpu_alerts" {
  name = "${var.infra_env}-instances-cpu-alerts"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email  # your email here
}

resource "aws_cloudwatch_metric_alarm" "frontend_cpu" {
  alarm_name          = "${var.infra_env}-frontend-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Alert if frontend CPU > 50%"
  alarm_actions       = [aws_sns_topic.cpu_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.frontend.id
  }
}

resource "aws_cloudwatch_metric_alarm" "backend_cpu" {
  alarm_name          = "${var.infra_env}-backend-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Alert if backend CPU > 50%"
  alarm_actions       = [aws_sns_topic.cpu_alerts.arn]

  dimensions = {
    InstanceId = aws_instance.backend.id
  }
}

data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}