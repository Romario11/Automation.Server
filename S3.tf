resource "aws_iam_role" "web_server_iam_role" {
  name = "web_server_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "Web server iam role",
    Project = var.project_name
  }
}

resource "aws_iam_instance_profile" "web_server_instance_profile" {
  name = "web_instance_profile"
  role = aws_iam_role.web_server_iam_role.id

  tags = {
    Name = "Web server iam instance profile",
    Project = var.project_name
  }
}

resource "aws_iam_role_policy" "s3_iam_role_policy" {
  name = "s3_iam_role_policy"
  role = aws_iam_role.web_server_iam_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "${aws_s3_bucket.my_site_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "${aws_s3_bucket.my_site_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "my_site_bucket" {
  bucket = "my-special-bucket-rs"
  force_destroy = true
  tags = {
    Name = "Web server s3 bucket",
    Project = var.project_name
  }
}

resource "aws_s3_bucket_acl" "my_site_bucket_acl" {
  bucket = aws_s3_bucket.my_site_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "my_site_bucket_versioning" {
  bucket = aws_s3_bucket.my_site_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_object" "my_web_site_objects_dirs" {
  bucket = aws_s3_bucket.my_site_bucket.id
  key = "index.html"
  source = "MySite/index.html"
  etag = filemd5("MySite/index.html")
}

