provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::324382802360:role/SSOAdmin"
    session_name = "SESSION_NAME_EU_WEST_1"
  }
  region  = "eu-west-1"
  version = ">= 2.38.0"
}

provider "http" {}
