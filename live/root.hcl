# Root Terragrunt 설정
locals {
  account_id = get_aws_account_id()
}

# Remote State 설정 (S3 Backend)
remote_state {
  backend = "s3"
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  
  config = {
    bucket         = "pey-terraform-state-${local.account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    use_lockfile = true
  }
}

# Provider 설정
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.region
}

variable "region" {
  type = string
}
EOF
}