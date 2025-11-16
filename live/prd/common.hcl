locals {
  common_inputs = {
    environment = "prd"
    region      = "ap-northeast-2"

    key_name = "ec2-prd-key"
    
    subnet_id              = "subnet-0f9f6702de3c40153"
    vpc_security_group_ids = ["sg-04d7644aa5406dfa8"]
    
    iam_instance_profile = "EC2RoleforSSM"
    ami = "ami-0c9c942bd7bf113a2"

    enable_root_volume_encryption = true
    root_volume_type              = "gp3"
    enable_ebs_volume_encryption  = true
    cpu_credits                   = "standard"
    
    enable_monitoring = true
  }
  
  common_tags = {
    ManagedBy   = "Terraform"
    Environment = "prd"
  }
}