resource "aws_ecr_repository" "test-gui" {
  name                 = var.ecr-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
