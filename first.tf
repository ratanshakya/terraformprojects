terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
variable "amiId"{
	default = "ami-013168dc3850ef002"
}
variable "osName"{
 default = "WelcomeOs"
}
provider "mycloud"{
	region = "ap-south-1"
 	
 }

resource "aws_instance" "os2" {
  count = 1
  ami = var.amiId 
  instance_type = "t2.micro"
  tags = { 
	   Name = var.osName
	 }
}

resource "aws_ebs_volume" "ebs" {
  availability_zone = aws_instance.os2[0].availability_zone
  size       = 1
  tags = {
    Name = "ebs_volume"
  }
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.os2[0].id	

}

output "instance_details" {
  value = [
    for instance in aws_instance.os2 :
    {
      public_ip = instance.public_ip
      key_name = instance.key_name
      subnet_id = instance.subnet_id
      vpc_security_group_ids = instance.vpc_security_group_ids
      availability_zone = instance.availability_zone

    }
  ]
}

output "ebs_details" {
value = aws_ebs_volume.ebs.id
}


