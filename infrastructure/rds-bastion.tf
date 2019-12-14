resource "aws_instance" "ec2-bastion" {
  ami                         = "ami-02dca57ad67c7bf57"
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id, aws_security_group.rds_sg.id]
  key_name                    = aws_key_pair.bastion.key_name
  instance_type               = "t3.medium"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = aws_subnet.private[0].id
  associate_public_ip_address = true
  ebs_optimized               = true
  disable_api_termination     = false
  monitoring                  = false

  root_block_device {
    volume_size           = 20
  }
  tags = {
    Name = "bastion-instance"
  }
}
