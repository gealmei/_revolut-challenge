resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "cluster-postgresql-revolut${count.index}"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = "db.r4.large"
  engine     = "aurora-postgresql"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "cluster-postgresql-revolut"
  engine                  = "aurora-postgresql"
  availability_zones      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  database_name           = "hello"
  master_username         = var.db-user
  master_password         = var.db-password
  backup_retention_period = 5
  preferred_backup_window = "05:00-07:00"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id] 
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "postgresql-subnet-group"
  description = "data subnets for rds"
  subnet_ids  = flatten([aws_subnet.data.*.id])
}
