################################################################
## S3 - CodePipeline artifact store
################################################################
resource "aws_s3_bucket" "tf-cicd-aws-codepipeline-artifact-store" {
  bucket = "${var.cicd_pipeline_s3_artifact_storename_prefix}-${var.ACTUAL_STAGE}"
  acl    = "private"
  region = var.AWS_REGION

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    prefix  = ""
    id      = "${var.cicd_pipeline_s3_artifact_storename_prefix}-${var.ACTUAL_STAGE}-object-expiration"
    enabled = true

    # Expire current version of object
    expiration {
      days = 30
    }

    # Permanently delete previous versions
    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = merge(
    map("Name", "${var.cicd_pipeline_s3_artifact_storename_prefix}-${var.ACTUAL_STAGE}"),
    var.DEFAULT_TAGS
  )
}

################################################################
## S3 - CodePipeline cache
################################################################
resource "aws_s3_bucket" "tf-cicd-aws-codepipeline-cache" {
  bucket = "${var.cicd_pipeline_s3_cache_name_prefix}-${var.ACTUAL_STAGE}"
  acl    = "private"
  region = var.AWS_REGION

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    prefix  = ""
    id      = "${var.cicd_pipeline_s3_cache_name_prefix}-${var.ACTUAL_STAGE}-object-expiration"
    enabled = true

    # Expire current version of object
    expiration {
      days = 30
    }

    # Permanently delete previous versions
    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = merge(
    map("Name", "${var.cicd_pipeline_s3_cache_name_prefix}-${var.ACTUAL_STAGE}"),
    var.DEFAULT_TAGS
  )
}
