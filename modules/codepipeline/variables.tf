variable "branch" {
  description = "Branches to be built"
  type        = string
}

variable "git_repository_name" {}

variable "codebuild_project_name" {}

variable "account_type" {
  description = "Human readable name of the targets accounts"
  type        = string
}

variable "pipeline_deployment_bucket_name" {
  description = "Bucket used by codepipeline and codebuild to store artifacts regarding the deployment"
  type        = string
}

variable "codepipeline_role_name" {
  description = "Name of the codepipeline role"
  type        = string
}

variable "codepipeline_policy_name" {
  description = "Name of the codepipeline policy"
  type        = string
}