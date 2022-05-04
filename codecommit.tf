resource "aws_codecommit_repository" "packer" {
  repository_name = "${var.friendly_name_prefix}-${var.codecommit_repository_name}"
  description     = var.codecommit_repository_description
}