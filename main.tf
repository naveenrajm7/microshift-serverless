terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "exp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "microshift-vpc"
  }
}

resource "aws_subnet" "exp_public_subnet" {
  vpc_id            = aws_vpc.exp_vpc.id
  cidr_block        = var.public_subnet
  availability_zone = var.aws_az

  tags = {
    Name = "microshift-public-subnet"
  }
}

resource "aws_internet_gateway" "exp_ig" {
  vpc_id = aws_vpc.exp_vpc.id

  tags = {
    Name = "exp-internet-gateway"
  }
}


resource "aws_route_table" "exp_public_rt" {
  vpc_id = aws_vpc.exp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.exp_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.exp_ig.id
  }

  tags = {
    Name = "exp-public-route-table"
  }
}

resource "aws_route_table_association" "exp_public_1_rt_a" {
  subnet_id      = aws_subnet.exp_public_subnet.id
  route_table_id = aws_route_table.exp_public_rt.id
}

resource "aws_security_group" "exp_sg" {
  name   = "PING and SSH"
  vpc_id = aws_vpc.exp_vpc.id

  ingress {
    description = "Ping"
    from_port   = 8 # Echo request
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "For security group"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress {
    description      = "Allow all outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "edge_node" {
  instance_type               = var.instance_type
  ami                         = var.instance_ami
  vpc_security_group_ids      = [aws_security_group.exp_sg.id]
  subnet_id                   = aws_subnet.exp_public_subnet.id
  private_ip                  = "198.18.60.10"
  key_name                    = var.instance_key
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/sdm"
    volume_size = 10
  }

  tags = {
    Name = "edge-node"
  }
}