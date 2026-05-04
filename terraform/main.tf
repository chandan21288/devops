

#vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
}

#subnet

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  
}

#internetgetway

resource "aws_internet_gateway" "agw" {
  vpc_id = aws_vpc.main.id
  
}

#routtable

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  
}

#route

resource "aws_route" "internet" {
  route_table_id = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.agw.id

}

#association
resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
  
}

#security group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}


#master node
resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "k8s-master"
  }
}

#worker node
resource "aws_instance" "worker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "k8s-worker"
  }
}