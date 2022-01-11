output "codecommit_url" {
value = "${aws.codecommit_repository.packer.clone_url_http}"
}