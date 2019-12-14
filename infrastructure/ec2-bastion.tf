data "template_file" "userdata" {
  template = file("files/userdata.tpl")

  vars = {
    region = var.region
    account-id = var.account-id
    ecr-name = var.ecr-name
    db-uri = aws_route53_record.cname.fqdn
    db-user = var.db-user 
    db-password = var.db-password
    image-tag = var.image-tag
  }
}

resource "aws_iam_role" "bastion" {
  name = "bastion-instance-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "bastion-EC2Profile"
  role = aws_iam_role.bastion.name
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion.pub"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCOaE3n/SvPe+VPYyneQPkawGE5WRDNZFrAa60Fw2/cfnZOfOy8v/WQdmXi927/O5GDGbWL8Gbs7BYj+htqmFtgbdFbtj/Qsuv8H/YhfHhwYGLXaIL04Fv8EvhS6ZF4Gl2QoGWuRudPlg2Qu3v8AWLTyBsj30CB2tbArgM7s9Xbcv4Oi2dHW6rT1+TAJYtOk8vHYg6lZQQNWBnTVCr0Sz4u8+PaKYBYcWlBB0rFKe2lk6xblQYAsdKKHeTYmCGBha4MOmvRm9vq7qt075Hqf61F7tc8rB0+DfLGvjhpDkoVULLGiFSNY3mSjAil4LWRVuWSHpltCMlRLHg2YLyKW6L"
}

resource "aws_instance" "ec2" {
  ami                         = "ami-02dca57ad67c7bf57"
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id]
  key_name                    = aws_key_pair.bastion.key_name
  instance_type               = "t3.medium"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  ebs_optimized               = true
  user_data                   = data.template_file.userdata.rendered
  disable_api_termination     = false
  monitoring                  = false

  root_block_device {
    volume_size           = 20
  }
  tags = {
    Name = "bastion-instance"
  }
}

resource "aws_iam_role_policy_attachment" "bastion-EKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.bastion.name
}

resource "aws_iam_role_policy_attachment" "bastion-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.bastion.name
}

resource "aws_iam_role_policy_attachment" "bastion-AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.bastion.name
}
