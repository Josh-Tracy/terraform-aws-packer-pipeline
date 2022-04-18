resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.pipeline_deployment_bucket_name}-codepipeline"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  # Needed for CloudWatch
  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {
  bucket                  = aws_s3_bucket.codepipeline_bucket.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
resource "aws_codepipeline" "codepipeline" {
  name     = var.git_repository_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source-${var.git_repository_name}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.git_repository_name
        BranchName     = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build-${var.codebuild_project_name}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = "test"
          },
          {
            name  = "PROJECT_NAME"
            value = var.account_type
        }])
      }
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = var.codepipeline_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = var.codepipeline_policy_name
  role = aws_iam_role.codepipeline_role.id

  policy = templatefile("${path.module}/templates/codepipeline-role-policy.json.tpl", {
    codepipeline_bucket_arn = aws_s3_bucket.codepipeline_bucket.arn
  })

}

resource "aws_iam_role_policy_attachment" "codepipeline_codecommit" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}