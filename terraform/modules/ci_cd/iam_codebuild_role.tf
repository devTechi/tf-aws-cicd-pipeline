########################################################################
## Trusted entity policy (who or which service can assume this role)
########################################################################
data "template_file" "tf-cicd-codebuild-role-trusted-entity" {
  template = "${file("${path.module}/templates/codebuild_role_policies/codebuild_role_trusted_entity.json")}"
}

resource "aws_iam_role" "tf-cicd-codebuild-role" {
  name = "${var.cicd_codebuild_iam_rolename_prefix}role-${var.ACTUAL_STAGE}"

  assume_role_policy = "${data.template_file.tf-cicd-codebuild-role-trusted-entity.rendered}"
}

########################################################################
## Attach a managed policy to the role
########################################################################
data "template_file" "tf-cicd-codebuild-role-access-policy" {
  template = "${file("${path.module}/templates/codebuild_role_policies/codebuild_role_access_policy.json")}"
}

resource "aws_iam_policy" "tf-cicd-codebuild-role-access-policy" {
  name        = "${var.cicd_codebuild_iam_rolename_prefix}auth-policy-${var.ACTUAL_STAGE}"
  description = "!!!ADMIN ACCESS!!!"
  policy      = "${data.template_file.tf-cicd-codebuild-role-access-policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-role-access-policy-attachment" {
  role       = "${aws_iam_role.tf-cicd-codebuild-role.name}"
  policy_arn = "${aws_iam_policy.tf-cicd-codebuild-role-access-policy.arn}"
}
