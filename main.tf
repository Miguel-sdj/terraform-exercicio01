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
}