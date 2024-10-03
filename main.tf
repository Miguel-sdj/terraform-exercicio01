provider "aws" {
  region = "us-east-2" 
}

module "vpc" {
  source = "./vpc/"
}
module "sg"{
    source = "./sg/"

}

module "asg" {
  source = "./asg/"
#   sg_public_ec2_id = module.sg.sg_public_ec2_id
#   subnet_public_id = module.vpc.subnet_public_id
}