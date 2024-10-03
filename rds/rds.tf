module "sg"{
    source = "../sg"
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  publicly_accessible  = false
  vpc_security_group_ids = [module.sg.sg_rds_id]

  backup_retention_period = 7
}

