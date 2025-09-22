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