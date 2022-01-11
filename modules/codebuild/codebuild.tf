resource "aws_s3_bucket" "packer_artifacts" {
  bucket = "terraform-packer-artifacts"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}


resource "aws_iam_role_policy_attachment" "codebuild_codecommit" {
  role       = aws_iam_role.packer_codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

resource "aws_iam_role_policy_attachment" "codebuild_deploy" {
  role       = aws_iam_role.packer_codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "packer_codebuild" {
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

resource "aws_iam_role_policy" "packer_codebuild" {
  role = aws_iam_role.packer_codebuild.name

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
            "${var.subnet_c_arn}"
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
        "${aws_s3_bucket.packer_artifacts.arn}",
        "${aws_s3_bucket.packer_artifacts.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "packer_build" {
  name          = "packer_build"
  description   = "test_codebuild_project"
  build_timeout = "10"
  service_role  = aws_iam_role.packer_codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.packer_artifacts.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "BUILD_OUTPUT_BUCKET"
      value = aws_s3_bucket.packer_artifacts.bucket
    }

    environment_variable {
      name  = "BUILD_VPC_ID"
      value = var.vpc_id
    }

    environment_variable {
      name  = "BUILD_SUBNET_ID"
      value = var.subnet_c_id
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.packer_artifacts.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"


  }


  vpc_config {
    vpc_id = var.vpc_id

    subnets = [
      var.subnet_c_id
    ]

    security_group_ids = var.security_group_id
  }

  tags = {
    Environment = "Test"
  }
}

