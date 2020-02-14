output "codecommit-repo-clone-url-http" {
  value = aws_codecommit_repository.tf-cicd-aws-resources.clone_url_http
}

output "codecommit-repo-clone-url-ssh" {
  value = aws_codecommit_repository.tf-cicd-aws-resources.clone_url_ssh
}
