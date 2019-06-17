# prefix for all resources
variable "NAMEPREFIX" {
  description = "Prefix for all resources beeing created from this scripts."
  type        = "string"
  default     = "tf-cicd-"                                                   # only lower case (because s3 buckets need to be lower case)
}

variable "AWS_REGION" {
  description = "Default region"
  type        = "string"
}

variable "ACTUAL_STAGE" {
  description = "Stage for deployments to different stages like dev/qa/prod"
  type        = "string"
}

# default tags for every created resource
# override following variable in terraform.tfvars if needed
variable "DEFAULT_TAGS" {
  description = "Default tags for every taggabble resource"
  type        = "map"

  default = {
    "CreatedBy"         = "project"
    "automated_through" = "Terraform"
    "service"           = "service"
    "Contact"           = "Bob"
    "Costcenter"        = "project"
  }
}

variable "TAGS_LIST_ENABLED" {
  description = "Is the nulldatasource tags_as_list_of_maps enabled"
  default     = false
}

# override following variable in terraform.tfvars
# tags for autoscaling group needs to be different, because these tags have the additional key 'propagate_at_launch' and others don`t
# using with autoscaling: 
# tags = ["${data.null_data_source.tags_as_list_of_maps.*.outputs}"]
data "null_data_source" "tags_as_list_of_maps" {
  description = "Autoscaling groups needs to get a tag-list instead of a map"
  count       = "${var.TAGS_LIST_ENABLED == "true" ? length(keys(var.DEFAULT_TAGS)) : 0}"

  inputs = "${map(
    "key", "${element(keys(var.DEFAULT_TAGS), count.index)}",
    "value", "${element(values(var.DEFAULT_TAGS), count.index)}",
    "propagate_at_launch", true
  )}"
}
