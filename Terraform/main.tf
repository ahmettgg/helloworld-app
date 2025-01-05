terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "testinium-tf-backend-github-actions"
    key = "backend/tf-backend-devops-task.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_instance" "managed_nodes" {
  ami = "ami-0fe630eb857a6ec83"
  count = 1
  instance_type = "t3.large" 
  key_name = "firstkey"
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  tags = {
    "key" = "testinium"
    "Name" = "testinium-devops-task"
  }
  user_data = file("terraform.sh")  
}

resource "aws_iam_role" "aws_access" {
  name = "devops-task-role" 
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_access_policy" {
  role       = aws_iam_role.aws_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
 
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "devops-task-profile"
  role = aws_iam_role.aws_access.name
}

resource "aws_security_group" "tf-sec-gr" {
  name = "project208-sec-gr"
  tags = {
    Name = "project208-sec-gr"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    protocol    = "tcp"
    to_port     = 8081
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9200
    protocol    = "tcp"
    to_port     = 9200
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9300
    protocol    = "tcp"
    to_port     = 9300
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



