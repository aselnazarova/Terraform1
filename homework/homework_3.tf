# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "aws_vpc" "asel_vpc" {
  cidr_block       = var.cidr_block_vpc 
  instance_tenancy = "default"

  tags = {
    Name = "asel_vpc"
  }
}

resource "aws_launch_template" "launch" {
  name                                  = "my_launch_template"
  image_id                              = var.ami 
  instance_initiated_shutdown_behavior  = "terminate"
  instance_type                         = var.instance_type
  key_name                              = var.key_name
  
  vpc_security_group_ids = [aws_security_group.sg_1.id]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_asel" {
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.subnet_asel.id]
  
  launch_template {
    id = aws_launch_template.launch.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "subnet_asel" {
  vpc_id     = aws_vpc.asel_vpc.id
  cidr_block = var.cidr_block_subnet1
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}


resource "aws_route_table" "r" {
  vpc_id = aws_vpc.asel_vpc.id

  route {
    cidr_block = var.cidr_block_route
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route_table"
  }
}

resource "aws_route_table_association" "route_associate" {
  subnet_id      = aws_subnet.subnet_asel.id
  route_table_id = aws_route_table.r.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.asel_vpc.id

  tags = {
    Name = "igw"
  }
}


resource "aws_key_pair" "tf_key" {
  key_name   = var.key_name
  public_key = file(var.ssh_key_path)
  }

resource "aws_security_group" "sg_1" {
  vpc_id      = aws_vpc.asel_vpc.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "http from VPC"
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
    Name = "allow_ssh_http"
  }
}

