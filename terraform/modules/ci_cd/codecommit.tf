resource "aws_codecommit_repository" "tf-cicd-aws-resources" {
  description     = "This is a repository for Terraform used by CodeBuild to handle AWS resources."
  repository_name = "${var.cicd_codecommit_repo_name}-${var.ACTUAL_STAGE}"
}
