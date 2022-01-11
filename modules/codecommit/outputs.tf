output "codecommit_url" {
value = "${aws_codecommit_repository.packer.clone_url_http}"
}

output "repository_name" {
value = "${aws_codecommit_repository.packer.repository_name}"
}