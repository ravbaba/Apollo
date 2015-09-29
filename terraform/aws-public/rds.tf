variable "rds_port" {
  default = 3306
}

variable "rds_instance_class" {
  default = "db.r3.large"
}

variable "rds_database_name" {
  default = "drupal8"
}

variable "rds_master_username" {
  default = "happy"
}

variable "rds_master_password" {
  default = "password_aurora"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier     = "aurora-cluster-demo"
  database_name          = "${var.rds_database_name}"
  master_username        = "${var.rds_master_username}"
  master_password        = "${var.rds_master_password}"
  port                   = "${var.rds_port}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.rds_public_subnet_group.name}"

  /*lifecycle {
    create_before_destroy = true
  }*/
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = 1
  cluster_identifier   = "${aws_rds_cluster.default.id}"
  instance_class       = "${var.rds_instance_class}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_public_subnet_group.name}"
}

resource "aws_db_subnet_group" "rds_public_subnet_group" {
  name        = "aurora-rds-public-subnetgroup"
  description = "Public subnets for RDS instance"
  subnet_ids  = [
    "${aws_subnet.public.0.id}",
    "${aws_subnet.public.1.id}",
    "${aws_subnet.public.2.id}",
  ]
}
