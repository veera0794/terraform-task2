provider "aws" {
    alias = "east"
    region = "us-east-2"  
}

provider "aws" {
    alias = "west"
    region = "us-west-1"  
}

variable "instance_type" {
  description = "Instance type for EC`2"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "my_ec2_east" {
  ami           = "ami-0d0f28110d16ee7d6"
  provider =  aws.east
  instance_type = var.instance_type 
  security_groups = [aws_security_group.web_sg_east_2.name]

  user_data = <<-EOF
                #!/bin/bash
                    sudo yum update -y
                    sudo yum install -y nginx
                    sudo systemctl start nginx
                    sudo systemctl enable nginx
                    EOF

    tags = {
        Name = "NginxServer"
    }
}

resource "aws_instance" "my_ec2_west" {
  ami           = "ami-01eb4eefd88522422"
  provider =  aws.west
  instance_type = var.instance_type 
  security_groups = [aws_security_group.web_sg_west_01.name]
}

output "instance_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.my_ec2_east.public_ip
 # value       = aws_instance.my_ec2_west.public_ip
}
resource "aws_security_group" "web_sg_east_2" {
  provider    = aws.east
  name        = "web_sg_east_2"
  description = "Allow SSH & HTTP access"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["3.147.70.119/32"]
  }

  ingress {
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
    Name = "WebSecurityGroup-Easts"
  }
}

resource "aws_security_group" "web_sg_west_01" {
    provider    = aws.west
    name        = "web_sg_west_01"
  description = "Allow SSH & HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "WebSecurityGroup-Easts"
  }
}
