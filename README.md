# 1. README

<!-- TOC -->

- [1. README](#1-readme)
- [2. How to use Terraform to build a CI/CD pipeline with AWS CodeCommit and CodeBuild](#2-how-to-use-terraform-to-build-a-cicd-pipeline-with-aws-codecommit-and-codebuild)
  - [2.1. Prerequisites](#21-prerequisites)
  - [2.2. Getting started](#22-getting-started)
    - [2.2.1. TL;DR](#221-tldr)

<!-- /TOC -->



# 2. How to use Terraform to build a CI/CD pipeline with AWS CodeCommit and CodeBuild

This project helps you to create a CI/CD pipeline within AWS using Terraform. After the creation you could use the very same CI/CD pipeline to create further AWS resources with another Terraform project.

## 2.1. Prerequisites
 - Configured local _awscli_ with files `~/.aws/config` and `~/.aws/credentials`
 - You can use [awsume](https://github.com/trek10inc/awsume) to switch between several profiles configured in `~/.aws/config`
   - Example `~/.aws/config` conent:
    
      ```
      # see: https://docs.aws.amazon.com/cli/latest/topic/config-vars.html
      [default]
      region = eu-central-1
      output = json

      [profile tf-role]
      source_profile = default
      role_arn = arn:aws:iam::123456789012:role/SomeIAMROLE
      mfa_serial = arn:aws:iam::123456789012:mfa/usersMFA
      ```
   - Example `~/.aws/credentials` conent:
    
      ```
      [default]
      aws_access_key_id = ACCESS_KEY_ID
      aws_secret_access_key = SECRET_ACCESS_KEY
      ```

   - With _awsume_ you can now use `awsume tf-role` and any further _aws_ interaction is done with the given role
   - __Also:__ with the given role you __define the target account__
 - Installed Terraform
   - See: [Installing Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
   - Or [on a Mac use brew](https://brewformulas.org/Terraform)
 - __Please don't save any ACCESS_KEY/SECRET_ACCESS_KEY inside your git repo__
   - To prevent this you can use [git-secrets](https://github.com/awslabs/git-secrets)
   - After generally installing _git-secrets_ go to your repository and type in `git secrets --install`


## 2.2. Getting started
### 2.2.1. TL;DR
To create a CI/CD pipeline with AWS resources only
 run `./runTerraform.sh your-state-s3-bucketname aws-region deployment-stage-string`

> IMPORTANT: During the `terraform apply` a IAM role with **_Admin Access_** will be created for CodeBuild!

With the repository [https://github.com/devTechi/tf-aws-cicd-pipeline-usage](https://github.com/devTechi/tf-aws-cicd-pipeline-usage)
you can use/test the created infrastructure of this repository.