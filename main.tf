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

resource "aws_db_instance" "test_db" {
  identifier             = "test"
  instance_class         = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.6"
  db_subnet_group_name   = module.vpc.subnet_group_db.name
  vpc_security_group_ids = [module.vpc.private_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

resource "aws_s3_bucket" "sammy-new-bucket-example" {
  bucket = "my-tf-test-bucket-sammy"
  tags = {
    Name        = "sammy-new-bucket-sept-25"
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.sammy-new-bucket-example.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "EC2S3AccessRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
}

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:ListBucket"]
    resources = [aws_s3_bucket.sammy-new-bucket-example.arn]
  }

  statement {
    effect = "Allow"
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.sammy-new-bucket-example.arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  name   = "S3AccessInlinePolicy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.s3_access_policy.json
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}