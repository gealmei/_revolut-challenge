resource "aws_subnet" "data" {
  vpc_id                  = aws_vpc.default.id
  count                   = length(split(",", local.availability_zones))
  cidr_block              = cidrsubnet(cidrsubnet(aws_vpc.default.cidr_block, 2, 2), var.newbits, count.index)
  availability_zone       = element(split(",", local.availability_zones), count.index)
  map_public_ip_on_launch = false
  depends_on              = [aws_nat_gateway.gw]

  tags = {
    Name = "${var.default_tag}-data-subnet"
  }
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.default_tag}-data-subnet"
  }
}

resource "aws_route_table_association" "data" {
  count          = length(split(",", local.availability_zones))
  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = aws_route_table.data.id
}
