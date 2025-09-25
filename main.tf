terraform {

    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc"{
    source = "./modules"
}


resource "aws_instance" "web_server" {
  ami           = "ami-08982f1c5bf93d976" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_id # Associates the instance with the subnet
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "web-server"
  }
}





