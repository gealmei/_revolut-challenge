resource "aws_iam_role" "eks-cluster" {
  name = "terraform-eks-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-EKSpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster-EKSsvcpolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "eks-revolut" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.sg-eks-cluster.id]
    subnet_ids         = aws_subnet.private[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-EKSpolicy,
    aws_iam_role_policy_attachment.cluster-EKSsvcpolicy,
  ]
}
