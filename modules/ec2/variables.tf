variable "create" {
  description = "Whether to create EC2 instance"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "cpu_credits" {
  description = "The credit option for CPU usage. Valid values: 'standard' or 'unlimited'. Only applicable for T2/T3/T4g instance types"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "unlimited"], var.cpu_credits)
    error_message = "CPU credits must be either 'standard' or 'unlimited'."
  }
}

variable "root_volume_type" {
  description = "Type of root volume. Valid values: standard, gp2, gp3, io1, io2, sc1, st1"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of the root volume in GiB"
  type        = number
  default     = 20
}

variable "enable_root_volume_encryption" {
  description = "Whether to enable root volume encryption"
  type        = bool
  default     = true
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices to attach to the instance"
  type = list(object({
    device_name           = string
    volume_type           = optional(string)
    volume_size           = optional(number)
    encrypted             = optional(bool)
    kms_key_id            = optional(string)
    delete_on_termination = optional(bool)
    tags                  = optional(map(string))
  }))
  default = []
}

variable "enable_ebs_volume_encryption" {
  description = "Whether to enable encryption for additional EBS volumes by default"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volumes"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the volumes"
  type        = map(string)
  default     = {}
}