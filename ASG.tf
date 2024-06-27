resource "aws_launch_template" "nginx" {
  name = "nginx-launch-template"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              EOF
  
  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.private_subnets[0].id
    security_groups             = [aws_security_group.nginx_sg.id]
  }
}

resource "aws_autoscaling_group" "nginx_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = aws_subnet.private_subnets.*.id
  launch_template {
    id = aws_launch_template.nginx.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.ionginx_vpc.id
  name   = "nginx-sg"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
