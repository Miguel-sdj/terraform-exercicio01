module "vpc" {
  source = "../vpc"
  # module.vpc.aws_vpc_id

}

resource "aws_security_group" "sg_public_ec2" {
  # vpc_id = aws_vpc.vpc.main_vpc.id
  vpc_id = module.vpc.aws_vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sg_public_ec2_id" {
  value = aws_security_group.sg_public_ec2.id
}

resource "aws_security_group" "sg_private_ec2" {
  vpc_id = module.vpc.aws_vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_public_ec2.id]
  }
}

output "sg_private_ec2_id" {
  value = aws_security_group.sg_private_ec2.id
}

resource "aws_security_group" "sg_rds" {
  vpc_id = module.vpc.aws_vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_private_ec2.id]
  }
}

output "sg_rds_id" {
  value = aws_security_group.sg_rds.id
}

resource "aws_security_group" "sg_alb" {
  vpc_id = module.vpc.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}