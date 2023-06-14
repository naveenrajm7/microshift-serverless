variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "aws_az" {
  description = "Availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "198.18.0.0/16" # RFC 2544, aws /15 not allowed
}

variable "public_subnet" {
  type    = string
  default = "198.18.60.0/24"
}

variable "instance_key" {
  description = "Key pair"
  type        = string
  default     = "micro"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t3.medium" 
  # (Edge Device) 
  # "t4g.small" [2CPU , 2G RAM] arm64  Arm-based AWS Graviton2 processors.
  # "t3.small" [2CPU, 2G RAM]  x86

  # General purpose
  # t3.medium [2, 4], t3.xlarge  [4CPU, 16G RAM] x86
  # t4g.medium [2, 4], t4g.xlarge [4CPU, 16G RAM] ARM
}

variable "instance_ami" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = "ami-026ebd4cfe2c043b2"
  # RHEL 9.2 : "ami-026ebd4cfe2c043b2"  x86_64 , "ami-03d6a5256a46c9feb"  arm64
  # RHEL 8.7 : "ami-08900fdabfe86d539"  x86_64 ,  "ami-00ed1846dde481e81" arm64 [us east 1]

  validation {
    condition     = length(var.instance_ami) > 4 && substr(var.instance_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}