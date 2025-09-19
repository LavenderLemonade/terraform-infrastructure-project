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

resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.main-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"


  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.main-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private2" {
    vpc_id     = aws_vpc.main-vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-08982f1c5bf93d976" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id # Associates the instance with the subnet
  tags = {
    Name = "web-server"
  }
}

resource "aws_db_subnet_group" "db_group" {
  name       = "db_group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

  tags = {
    Name = "database"
  }
}

# Create a private security group within the VPC
resource "aws_security_group" "private_sg" {
  name        = "private-security-group"
  description = "Security group for private resources"
  vpc_id      = aws_vpc.main-vpc.id # Associate with the created VPC

  # Ingress rules (inbound traffic)
  ingress {
    description = "Allow SSH from within the VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main-vpc.cidr_block] # Allow SSH from any IP within the VPC
  }

  ingress {
    description = "Allow HTTP from within the VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main-vpc.cidr_block] # Allow HTTP from any IP within the VPC
  }

  # Egress rules (outbound traffic)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 signifies all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound to all IP addresses
  }

  tags = {
    Name = "private-sg"
  }
}


resource "aws_db_instance" "test_db" {
  identifier             = "test"
  instance_class         = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.6"
  db_subnet_group_name   = aws_db_subnet_group.db_group.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

