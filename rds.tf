resource "aws_db_instance" "test_db" {
  identifier             = "test"
  instance_class         = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.6"
  db_subnet_group_name   = module.vpc.subnet_group_db.name
  vpc_security_group_ids = [module.vpc.private_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}