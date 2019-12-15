resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.default.id
  count                   = length(split(",", local.availability_zones))
  cidr_block              = cidrsubnet(cidrsubnet(aws_vpc.default.cidr_block, 2, 0), var.newbits, count.index)
  availability_zone       = element(split(",", local.availability_zones), count.index)
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.default]

  tags = {
    Name                                        = "${var.default_tag}-public-subnet",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.default_tag}-public-subnet"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public" {
  count          = length(split(",", local.availability_zones))
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
