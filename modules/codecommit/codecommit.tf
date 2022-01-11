resource "aws_codecommit_repository" "packer" {
  repository_name = var.codecommit_repository_name
  description     = var.codecommit_repository_descriptions
}