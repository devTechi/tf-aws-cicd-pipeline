# https://www.terraform.io/docs/providers/aws/r/codebuild_project.html
################################################################
## Terraform PLAN
################################################################
resource "aws_codebuild_project" "tf-plan-cicd-manage-aws-resources" {
  name          = "${var.cicd_codebuild_tf_plan_name}-${var.ACTUAL_STAGE}"
  description   = "Run Terraform code inside CodeBuild"
  build_timeout = "5"
  service_role  = aws_iam_role.tf-cicd-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    # type = "NO_CACHE"
    type     = "S3"
    location = "${aws_s3_bucket.tf-cicd-aws-codepipeline-cache.bucket}/cache_codebuild"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL" # see: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    image        = "hashicorp/terraform:${var.tf_version}"
    type         = "LINUX_CONTAINER"

    # image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_ROLE"
      value = aws_iam_role.tf-cicd-codebuild-role.arn
    }

    # environment_variable {
    #   "name"  = "KeyInParameterStore"
    #   "value" = "ValueOfKeyInParameterStore"
    #   "type"  = "PARAMETER_STORE"
    # }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec_tf_plan.yml"
    git_clone_depth = 1
  }

  tags = merge(
    map("Name", "${var.cicd_codebuild_tf_plan_name}-${var.ACTUAL_STAGE}"),
    map("Environment", "${var.ACTUAL_STAGE}"),
    var.DEFAULT_TAGS
  )
}

################################################################
## Terraform APPLY
################################################################
resource "aws_codebuild_project" "tf-apply-cicd-manage-aws-resources" {
  name          = "${var.cicd_codebuild_tf_apply_name}-${var.ACTUAL_STAGE}"
  description   = "Run Terraform code inside CodeBuild"
  build_timeout = "5"
  service_role  = aws_iam_role.tf-cicd-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.tf-cicd-aws-codepipeline-cache.bucket}/cache_codebuild"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL" # see: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
    image        = "hashicorp/terraform:${var.tf_version}"
    type         = "LINUX_CONTAINER"

    # image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_ROLE"
      value = aws_iam_role.tf-cicd-codebuild-role.arn
    }

    # environment_variable {
    #   "name"  = "KeyInParameterStore"
    #   "value" = "ValueOfKeyInParameterStore"
    #   "type"  = "PARAMETER_STORE"
    # }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec_tf_apply.yml"
    git_clone_depth = 1
  }

  tags = merge(
    map("Name", "${var.cicd_codebuild_tf_apply_name}-${var.ACTUAL_STAGE}"),
    map("Environment", "${var.ACTUAL_STAGE}"),
    var.DEFAULT_TAGS
  )
}
