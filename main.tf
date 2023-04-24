# crate a custom vpc 

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MyVpc"
  }
}

# create subnet1 as public 
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "SUbnet1_Public_Myvpc"
  }
}

# create subnet2 as private 
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "SUbnet2_Private_Myvpc"
  }
}

# crate a internetgateway for vpc
resource "aws_internet_gateway" "myvpcigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "MyVpc_igw"
  }
}

# create a route table for Public Sudbnet 
resource "aws_route_table" "Publicrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpcigw.id
  }

  tags = {
    "Name" = "PublicRT_MyVpc"
  }
}

# Associate subnet1 with publicRT 
resource "aws_route_table_association" "publicsubnet1assosiate" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.Publicrt.id
}

# create security group for instance 
resource "aws_security_group" "Mysec_grp" {
  name        = "TRAFFIC RULE"
  description = "Allow All inbound traffic"
  vpc_id      = aws_vpc.myvpc.id
  ingress {
    description      = "ALLOW ALL TRAFFIC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "MySecgrp"
  }
}

