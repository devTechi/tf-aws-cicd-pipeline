data "aws_caller_identity" "current" {}

# Use Terraforms ability of modules and handover some variable values
module "cicd" {
  source = "./modules/ci_cd"

  AWS_REGION   = var.AWS_REGION
  NAMEPREFIX   = var.NAMEPREFIX
  DEFAULT_TAGS = var.DEFAULT_TAGS
  ACTUAL_STAGE = var.ACTUAL_STAGE

  tf_version                                 = "0.12.20"
  cicd_codecommit_repo_name                  = "${var.NAMEPREFIX}aws-resource-creation"
  cicd_codebuild_tf_plan_name                = "${var.NAMEPREFIX}aws-tf-plan"
  cicd_codebuild_tf_apply_name               = "${var.NAMEPREFIX}aws-tf-apply"
  cicd_codebuild_iam_rolename_prefix         = "${var.NAMEPREFIX}codebuild"
  cicd_pipeline_s3_artifact_storename_prefix = "${var.NAMEPREFIX}${data.aws_caller_identity.current.account_id}-artifacts"
  cicd_pipeline_s3_cache_name_prefix         = "${var.NAMEPREFIX}${data.aws_caller_identity.current.account_id}-caches"
  cicd_pipeline_name                         = "${var.NAMEPREFIX}aws-resource-creation"
  cicd_pipeline_iam_rolename_prefix          = "${var.NAMEPREFIX}pipeline"
}
