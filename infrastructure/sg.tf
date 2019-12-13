resource "aws_security_group" "sg-eks-cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-sg"
  }
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-eks-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group" "sg-bastion" {
  name        = "bastion-sg"
  description = "ssh access"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group_rule" "bastion-ingress-ssh" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow ssh access"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-bastion.id
  to_port           = 22
  type              = "ingress"
}
