resource "aws_vpc" "main_vpc" {
  cidr_block = "172.31.0.0/16"
}

# Criação da Subnet Pública
resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "172.31.1.0/24"
  map_public_ip_on_launch = true
}

output "subnet_public_id" {
  value = aws_subnet.subnet_public.id
}

# Criação da Subnet private 
resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "172.31.2.0/24"
}

output "subnet_private_id" {
  value = aws_subnet.subnet_private.id
}

# Criação da Subnet private 2 
resource "aws_subnet" "subnet_private2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "172.31.3.0/24"
}

# Criando o internet gateway
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Criando a rota para internet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
}

# Associando a subnet publica com a rota publica
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.public_rt.id
}

output "aws_vpc_id" {
  value = aws_vpc.main_vpc.id
}