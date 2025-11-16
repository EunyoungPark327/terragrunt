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
    name             = "data-ec2-prd"
    instance_type    = "c6i.large"
    root_volume_size = 30
    
    tags = merge(
      include.common.locals.common_tags,
      {
        Team    = "Data"
      }
    )
  }
)