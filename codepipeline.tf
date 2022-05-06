resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.friendly_name_prefix}-codepipeline"
}

resource "aws_s3_bucket_acl" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.friendly_name_prefix}-pipeline"
  role_arn = aws_iam_role.codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source-${aws_codecommit_repository.packer.repository_name}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.packer.repository_name
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
        ProjectName = aws_codebuild_project.packer-build.name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = "test"
          },
          {
            name  = "PROJECT_NAME"
            #value = var.account_type
        }])
      }
    }
  }
}

resource "aws_iam_role" "codepipeline-role" {
  name = "CodepipelineS3andCodebuildAccess"

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

resource "aws_iam_role_policy" "codepipeline-policy" {
  name = "CodepipelineS3andCodebuildAccess"
  role = aws_iam_role.codepipeline-role.id

  policy = templatefile("${path.module}/templates/codepipeline-role-policy.json.tpl", {
    codepipeline_bucket_arn = aws_s3_bucket.codepipeline.arn
  })

}

resource "aws_iam_role_policy_attachment" "codepipeline-codecommit" {
  role       = aws_iam_role.codepipeline-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}