#!/bin/bash

if [[ -z $1  || -z $2 || -z $3 ]]; then
  echo "Usage: ./runTerraform.sh STATE_BUCKET_NAME REGION_LIKE_eu-central-1 STAGE_LIKE_dev"
  
  exit 1
fi

# Variables definitions, which are used to be able to switch easily to another account etc.
STATE_BUCKET_NAME=$1
REGION=$2
STAGE=$3
PROJECTNAME="tf-aws-cicd-pipeline"

# remove former existing local .terraform folder
rm -rf .terraform

# Init Terraform backend
terraform init -backend-config="region=$REGION" \
  -backend-config="bucket=$STATE_BUCKET_NAME" \
  -backend-config="key=$PROJECTNAME-$STAGE/$PROJECTNAME-$STAGE.tfstate" ./terraform/
  
# Plan the changes
terraform plan \
  -var AWS_REGION="$REGION" \
  -var ACTUAL_STAGE="$STAGE" \
  ./terraform/

# exit 0
# Apply the changes and ask to do so
terraform apply \
  -input=false \
  -var AWS_REGION="$REGION" \
  -var ACTUAL_STAGE="$STAGE" \
  ./terraform/