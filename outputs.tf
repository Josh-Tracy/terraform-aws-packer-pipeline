#----------------------------------------------------#
# VPC outputs
#----------------------------------------------------#
output "vpc_id" {
  value = aws_vpc.vpc[0].id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a[0].id
}

output "subnet_a_arn" {
  value = aws_subnet.subnet_a[0].arn
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b[0].id
}

output "subnet_b_arn" {
  value = aws_subnet.subnet_b[0].arn
}

output "subnet_c_id" {
  value = aws_subnet.subnet_c[0].id
}

output "subnet_c_arn" {
  value = aws_subnet.subnet_c[0].arn
}

output "public_subnets" {
  value = [aws_subnet.subnet_a[0].id, aws_subnet.subnet_b[0].id]
}

output "private_subnets" {
  value = aws_subnet.subnet_c[0].id
}

output "security_group_id" {
  value = aws_security_group.codebuild.id
}
#----------------------------------------------------#
# Code Commit outputs
#----------------------------------------------------#

output "codecommit_url" {
  value = aws_codecommit_repository.packer.clone_url_http
}

output "repository_name" {
  value = aws_codecommit_repository.packer.repository_name
}
#----------------------------------------------------#
# Code Build outputs
#----------------------------------------------------#

output "codebuild_project_name" {
  value = aws_codebuild_project.packer-build.name
}