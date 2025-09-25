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