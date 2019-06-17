################################################################
## Defaults for all modules
################################################################
variable "NAMEPREFIX" {} # not used right now

variable "ACTUAL_STAGE" {}

variable "AWS_REGION" {}

# default tags for every created resource
variable "DEFAULT_TAGS" {
  type    = "map"
  default = {}
}
