#variable "codebuild_source_repository" {}

variable "buildspec_path" {
  description = "Path to the buildspec file"
  type        = string
}

variable "image" {
  description = "Container image for codebuild to use"
  type        = string

}
variable "type" {
  description = "What kind of image are you using? container or ?"
  type        = string

}
variable "compute_type" {
  description = "Size of the compute type to use"
  type        = string

}
variable "image_pull_credentials_type" {
  description = "Type of credentials to use to pull cotnainer image from registrry"
  type        = string
}

variable "build_timeout" {
  description = "Time elapsed before build forfiets"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name of the codebuild project"
  type        = string
}

variable "codebuild_project_description" {
  description = "Description of the codebuild project"
  type        = string
}

variable "vpc_id" {}

variable "subnet_c_arn" {}

variable "subnet_c_id" {}

variable "subnet_a_id" {}

variable "security_group_id" {}

variable "git_repository_name" {}
