variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "I KNOW, SHOULD BE AT LEAST IN SECRET MANAGER, BUT FOR DEMO PURPOSES..."
  type        = string
  default     = "IAmSuperSecret!"
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "main-database"
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnets"
  subnet_ids = values(aws_subnet.private)[*].id
}

resource "aws_db_instance" "main" {
  identifier            = var.db_identifier
  engine                = "postgres"
  engine_version        = "17.5"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp3"
  db_subnet_group_name  = aws_db_subnet_group.main.name
  publicly_accessible   = false

  username = var.db_username
  password = var.db_password

  db_name = var.db_name

  vpc_security_group_ids = [aws_security_group.main_db_sg.id]

  # added for development convenience and cost savings
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
}

resource "aws_security_group" "main_db_sg" {
  name   = "main-db-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.main_instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "db_ip_address" {
  value = aws_db_instance.main.address
}
