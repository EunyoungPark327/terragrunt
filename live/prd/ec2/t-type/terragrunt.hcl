include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/modules/ec2"
}

inputs = merge(
  include.common.locals.common_inputs,
  {
    name             = "devops-ec2-prd"
    instance_type    = "t3.medium"
    root_volume_size = 20
    cpu_credits      = "standard" # standard | unlimited
    
    tags = merge(
      include.common.locals.common_tags,
      {
        Team       = "DevOps"
      }
    )
  }
)