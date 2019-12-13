resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "cluster-postgresql-test-gui${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.r4.large"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "cluster-postgresql-test-gui"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name      = "hello"
  master_username    = "test"
  master_password    = "test123456"
}
