# Configure the AWS Provider
# see: https://www.terraform.io/docs/providers/aws/
provider "aws" {
  region = "${var.AWS_REGION}"

  # if you need a version
  #version = "~> 1.50"
}
