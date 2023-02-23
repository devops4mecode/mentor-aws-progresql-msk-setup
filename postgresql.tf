module "postgresql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.0.0"

  db_name           = "my_database"
  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = "db.t3.micro"
  username          = "my_user"
  password          = "my_password"
  allocated_storage = 20

  vpc_security_group_ids = [aws_security_group.msk_connector_sg.id]

  tags = {
    Name = "my_database"
  }
}

resource "aws_security_group" "msk_connector_sg" {
  name_prefix = "msk_connector_sg"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
