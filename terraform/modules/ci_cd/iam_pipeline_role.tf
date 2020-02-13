########################################################################
## Trusted entity policy (who or which service can assume this role)
########################################################################
data "template_file" "tf-cicd-pipeline-role-trusted-entity" {
  template = "${file("${path.module}/templates/pipeline_role_policies/pipeline_role_trusted_entity.json")}"
}

resource "aws_iam_role" "tf-cicd-pipeline-role" {
  name = "${var.cicd_pipeline_iam_rolename_prefix}-role-${var.ACTUAL_STAGE}"

  assume_role_policy = data.template_file.tf-cicd-pipeline-role-trusted-entity.rendered
}

########################################################################
## Attach a managed policy to the role
########################################################################
data "template_file" "tf-cicd-pipeline-role-access-policy" {
  template = "${file("${path.module}/templates/pipeline_role_policies/pipeline_role_access_policy.json")}"

  vars = {
    CodeCommitRepo    = aws_codecommit_repository.tf-cicd-aws-resources.arn
    ArtifactsS3Bucket = aws_s3_bucket.tf-cicd-aws-codepipeline-artifact-store.arn
    CachesS3Bucket    = aws_s3_bucket.tf-cicd-aws-codepipeline-cache.arn
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-role-access-policy" {
  name        = "${var.cicd_pipeline_iam_rolename_prefix}-auth-policy-${var.ACTUAL_STAGE}"
  description = "!!!ADMIN ACCESS!!!"
  policy      = data.template_file.tf-cicd-pipeline-role-access-policy.rendered
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-role-access-policy-attachment" {
  role       = aws_iam_role.tf-cicd-pipeline-role.name
  policy_arn = aws_iam_policy.tf-cicd-pipeline-role-access-policy.arn
}
