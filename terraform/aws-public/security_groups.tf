/* Default security group */
resource "aws_security_group" "default" {
  name        = "default-apollo-mesos"
  description = "Default security group that allows all traffic"
  vpc_id      = "${aws_vpc.default.id}"

  # Allows inbound and outbound traffic from all instances in the VPC.
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  # Allows all inbound traffic from the internet.
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "apollo-mesos-default-security-group"
  }
}

/* RDS security group */
resource "aws_security_group" "rds" {
  name        = "rds-apollo-group"
  description = "Allow MySQL traffic to rds"
  vpc_id      = "${aws_vpc.default.id}"

  # Allows all inbound traffic from the internet.
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "apollo-rds-security-group"
  }
}
