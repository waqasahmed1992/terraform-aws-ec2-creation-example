variable "associate_public_ip_address" {
  description = "Associate a public IP address with EC2 instance"
  type        = bool
  default     = true
}
variable "servername" {
  description = "Name of the server"
  type        = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami" {
  type    = string
  default = ""
}

#Variable that will contain a list of map types
variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}