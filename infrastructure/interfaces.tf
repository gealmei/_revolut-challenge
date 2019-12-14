//INPUTS

variable "vpc_cidr" {
  default     = "172.17.0.0/16"
  description = "VPC IP range in CIDR notation (including mask)"
}

variable "region" {
  description = "Allows user to control region to work in. Defaults to the one configured in current provider"
  default     = "eu-west-1"
}

variable "azs" {
  description = "Allows user to control availability zones to work in. Defaults to all possible zones available in the current region"
  type        = map
  default     = {}
}

variable "newbits" {
  description = "Makes an IP address range in CIDR notation (like 10.0.0.0/8) and extends its prefix to include an additional subnet number. For example, cidrsubnet('10.0.0.0/8', 8, 2) returns 10.2.0.0/16."
  default     = "2"
}

variable "default_tag" {
  type        = string
  default     = "revolut-challenge"
}

variable "cluster-name" {
  type = string
  default = "eks-revolut"
}

locals {
  region             = "${length(var.region) != 0 ? var.region : data.aws_region.current.name}"
  availability_zones = "${lookup(var.azs, local.region, join(",", data.aws_availability_zones.available.names))}"
}

variable "ecr-name" {
  default = "ecr-hello"
}

variable "db-user" {
  default = "guilherme"
}

variable "db-password" {
  default = "Eeghae+g2o"
}

variable "image-tag" {
  default = "latest"
}
