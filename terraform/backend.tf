data "aws_ami" "amzn_linx_lts" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "main" {
  ami                    = data.aws_ami.amzn_linx_lts.id
  instance_type          = "t4g.micro"
  key_name               = "tesetkey"
  vpc_security_group_ids = [aws_security_group.main_instance_sg.id]
  subnet_id              = values(aws_subnet.public)[0].id
  user_data              = <<-EOF
#!/bin/bash
sudo yum install -y git docker
sudo yum update -y
systemctl start docker
systemctl enable docker
git clone https://github.com/ruskoloma/test100500.git /home/ec2-user/app
cd /home/ec2-user/app
docker compose up -d
EOF
}

resource "aws_security_group" "main_instance_sg" {
  name        = "main-instance-sg"
  description = "allow ssh and http traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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

output "instance_ip_address" {
  value = aws_instance.main.public_ip
}

