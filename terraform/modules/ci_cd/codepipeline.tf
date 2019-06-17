resource "aws_codepipeline" "tf-cicd-aws-resources" {
  name     = "${var.cicd_pipeline_name}-${var.ACTUAL_STAGE}"
  role_arn = "${aws_iam_role.tf-cicd-pipeline-role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.tf-cicd-aws-codepipeline-artifact-store.bucket}"
    type     = "S3"

    # encryption_key
    # --> The encryption key block AWS CodePipeline uses to encrypt the
    # data in the artifact store, such as an AWS Key Management Service (AWS KMS) key.
    # If you don't specify a key, AWS CodePipeline uses the default key for Amazon
    # Simple Storage Service (Amazon S3).
  }

  # see: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements
  stage {
    name = "Get-the-tf-sources"

    action {
      name     = "Terraform-Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"

      output_artifacts = ["SourceArtifacts"]

      configuration {
        RepositoryName = "${aws_codecommit_repository.tf-cicd-aws-resources.repository_name}"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Run-Terraform"

    action {
      name      = "Plan-TF"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      input_artifacts  = ["SourceArtifacts"]
      output_artifacts = ["PlanArtifacts"]

      configuration {
        ProjectName = "${aws_codebuild_project.tf-plan-cicd-manage-aws-resources.name}"
      }
    }

    action {
      name      = "Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      run_order = 2
      version   = "1"

      # configuration {
      #   NotificationArn = "${var.approve_sns_arn}"
      #   CustomData      = "${var.approve_comment}"
      # }
    }

    action {
      name      = "Apply-TF"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 3

      input_artifacts  = ["PlanArtifacts"]
      output_artifacts = ["ApplyArtifacts"]

      configuration {
        ProjectName = "${aws_codebuild_project.tf-apply-cicd-manage-aws-resources.name}"

        # PrimarySource = "SourceArtifacts"
      }
    }
  }
}
