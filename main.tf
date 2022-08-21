data "aws_ami" "default" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami                         = var.ami != "" ? var.ami : data.aws_ami.default.image_id
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = var.associate_public_ip_address

  #dynamic block with for_each loop
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }
  tags = {
    Name = "${var.servername}"
  }
}

#public IP address with Count Conditional Expression
resource "aws_eip" "pip" {
  count = var.associate_public_ip_address ? 1 : 0
  # if var.associate_public_ip is set to true than count =1, if false count =0 (don't create)
  network_interface = aws_instance.server.primary_network_interface_id
  vpc               = true
}

