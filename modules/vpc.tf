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