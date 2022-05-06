locals {
  ec2_subnet = (var.create_vpc == true ? aws_subnet.subnet_c[0].arn : var.subnet_c_arn )
}

resource "aws_s3_bucket" "packer-artifacts" {
  bucket = "terraform-packer-artifacts"
}
resource "aws_s3_bucket_acl" "packer-artifacts" {
  bucket = aws_s3_bucket.packer-artifacts.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "packer-artifacts" {
  bucket = aws_s3_bucket.packer-artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "packer-artifacts" {
  bucket = aws_s3_bucket.packer-artifacts.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}


resource "aws_iam_role_policy_attachment" "codebuild-codecommit" {
  role       = aws_iam_role.packer-codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.packer-codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "packer-codebuild" {
  name = "codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "packer-codebuild" {
  role = aws_iam_role.packer-codebuild.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:Subnet": [
            "${local.ec2_subnet}"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.packer-artifacts.arn}",
        "${aws_s3_bucket.packer-artifacts.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "packer-build" {
  name          = var.codebuild_project_name
  description   = var.codebuild_project_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.packer-codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.packer-artifacts.bucket
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_credentials_type

    environment_variable {
      name  = "BUILD_OUTPUT_BUCKET"
      value = aws_s3_bucket.packer-artifacts.bucket
    }

    environment_variable {
      name  = "BUILD_VPC_ID"
      value = var.create_vpc == true ? aws_vpc.vpc[0].id : var.vpc_id
    }

    environment_variable {
      name  = "BUILD_SUBNET_ID"
      value = var.create_vpc == true ? aws_subnet.subnet_a[0].id : var.build_subnet_id
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.packer-artifacts.id}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_path


  }


  vpc_config {
    # ID of the VPC within which to run builds
    vpc_id = var.create_vpc == true ? aws_vpc.vpc[0].id : var.vpc_id
    # Subnet IDs within which to run builds
    subnets = [
      var.create_vpc == true ? aws_subnet.subnet_c[0].id : var.build_subnet_id
    ]
    # Security group IDs to assign to running builds
    security_group_ids = [aws_security_group.codebuild.id]
  }
}

