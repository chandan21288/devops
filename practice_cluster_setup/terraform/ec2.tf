provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "terraform_sg" {
  name = "terraform_sg"

  ingress = {
    from_port   =   22
    to_port     =   22
    protocol    =  "tcp"
    cidr_blocks =   ["0.0.0.0/0"]

  }

  egress = {
    from_port   =   0
    to_port     =   0
    protocol    =   "-1"
    cidr_block  =   ["0.0.0.0/0"]
  }

}

resource "aws_instance" "controller_server" {
  ami = "ami-01b40e1bcccae197a"
  instance_type = "t3.micro"
  key_name = "terraform-key"

  vpc_security_group_ids = [aws_security_group.terraform_sg]

  tags = {
    Name    =   "devops-controller"
  }
}