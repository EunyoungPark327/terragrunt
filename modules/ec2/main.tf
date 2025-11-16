terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# T Type 체크
locals {
  is_t_instance = length(regexall("^t[2-4]g?\\.", var.instance_type)) > 0
  
  # 태그 병합
  merged_tags = merge(
    {
      Name        = var.name
      ManagedBy   = "Terraform"
      Environment = var.env
    },
    var.tags
  )
}

# EC2 인스턴스 생성
resource "aws_instance" "this" {
  count = var.create ? 1 : 0

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  
  # 모니터링
  monitoring = var.enable_monitoring
  
  ebs_optimized = true

  dynamic "credit_specification" {
    for_each = local.is_t_instance ? [1] : []
    content {
      cpu_credits = var.cpu_credits
    }
  }

  # Root 블록 디바이스 설정
  root_block_device {
    encrypted             = var.enable_root_volume_encryption
    kms_key_id            = var.kms_key_id
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  # 추가 EBS 볼륨
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = lookup(ebs_block_device.value, "volume_type", "gp3")
      volume_size           = lookup(ebs_block_device.value, "volume_size", 20)
      encrypted             = lookup(ebs_block_device.value, "encrypted", var.enable_ebs_volume_encryption)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", var.kms_key_id)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
    }
  }

  # 인스턴스 태그
  tags = local.merged_tags

  # 볼륨 태그
  volume_tags = merge(
    local.merged_tags,
    var.volume_tags
  )

  lifecycle {
    ignore_changes = [ami]
  }
}