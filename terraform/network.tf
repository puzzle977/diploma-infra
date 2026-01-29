resource "yandex_vpc_network" "vpc" {
  name = "diploma-vpc"
}

# --------------------
# Публичная подсеть
# --------------------
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.public_cidr]
}

# --------------------
# NAT Gateway
# --------------------
resource "yandex_vpc_gateway" "nat" {
  name = "nat-gw"

  shared_egress_gateway {}
}

# --------------------
# Route table для приватных подсетей
# --------------------
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-rt"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

# --------------------
# Приватная подсеть A
# --------------------
resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.private_a_cidr]

  route_table_id = yandex_vpc_route_table.private_rt.id
}

# --------------------
# Приватная подсеть B
# --------------------
resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.private_b_cidr]

  route_table_id = yandex_vpc_route_table.private_rt.id
}
