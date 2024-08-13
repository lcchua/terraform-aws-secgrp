
#============ VARIABLES =============

variable "region" {
  description = "Name of aws region"
  type        = string
  default     = "us-east-1"
}

variable "stack_name" {
  type    = string
  default = "lcchua-STW"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "lcchua-useast1-20072024" # Change accordingly
}

#============ MAIN =============

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # To comment backend block if working on local and terraform state file is locally stored
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "terraform-ex-ec2-lcchua.tfstate"
    region = "us-east-1"
  }
}

# Indicate the provider's region
provider "aws" {
  region = var.region
}


#============ SECURITY GROUP =============

resource "aws_security_group" "lcchua-tf-sg-allow-ssh" {
  name   = "lcchua-tf-sg-allow-ssh"
  vpc_id = "vpc-0444ca4b865539c2d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "allow ssh port"
    cidr_blocks = ["116.86.159.189/32","18.206.107.24/29"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    group = var.stack_name
    Name  = "stw-sg-ssh"
  }
}
output "ssh-sg" {
  description = "16 stw web security group for ssh"
  value       = aws_security_group.lcchua-tf-sg-allow-ssh.id
}
