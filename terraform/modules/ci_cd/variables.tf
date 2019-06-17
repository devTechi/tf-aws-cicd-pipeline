variable "tf_version" {
  description = "Version of Terraform to be used."
  type        = "string"
}

variable "cicd_codecommit_repo_name" {
  description = "The name of the CodeCommit git repository."
  type        = "string"
}

variable "cicd_codebuild_tf_plan_name" {
  description = "The name of the CodeBuild project to run a 'terraform plan'."
  type        = "string"
}

variable "cicd_codebuild_tf_apply_name" {
  description = "The name of the CodeBuild project to run a 'terraform apply'."
  type        = "string"
}

variable "cicd_codebuild_iam_rolename_prefix" {
  description = "The name IAM role used by CodeBuild."
  type        = "string"
}

variable "cicd_pipeline_s3_artifact_storename_prefix" {
  description = "The name of the S3 bucket which stores the artifacts of the builds."
  type        = "string"
}

variable "cicd_pipeline_s3_cache_name_prefix" {
  description = "The name of the S3 bucket which stores the caches of the builds."
  type        = "string"
}

variable "cicd_pipeline_name" {
  description = "The name of the CodePipeline."
  type        = "string"
}

variable "cicd_pipeline_iam_rolename_prefix" {
  description = "The name IAM role used by CodePipeline."
  type        = "string"
}
