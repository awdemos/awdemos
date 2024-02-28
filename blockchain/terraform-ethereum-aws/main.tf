provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.r.id
}

resource "aws_security_group" "allow_ethereum" {
  name        = "allow_ethereum"
  description = "Allow Ethereum related traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8545
    to_port     = 8545
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

resource "aws_instance" "ethereum_node" {
  ami                    = "ami-0a62a741df1d21fab" // Use the latest Ubuntu 20.04 LTS AMI for us-west-2
  instance_type          = "m5.large"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ethereum.id]
  key_name               = "your_keypair" // Replace with your key pair for SSH access

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install software-properties-common -y
                sudo add-apt-repository -y ppa:ethereum/ethereum
                sudo apt update
                sudo apt install ethereum -y
                geth --syncmode "fast" --cache=2048 \
                     --http --http.addr "0.0.0.0" --http.port "8545" \
                     --http.corsdomain "*" --http.api "eth,net,web3,personal" \
                     --bootnodes "v4.bootnode.ethnodes.org"
                EOF

  tags = {
    Name = "EthereumNode"
  }

  root_block_device {
    volume_size = 2500 // 2.5 TB SSD
  }
}


