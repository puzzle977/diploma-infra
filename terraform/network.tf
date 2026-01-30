resource "yandex_vpc_network" "vpc" {
  name = "diploma-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.public_cidr]
}

resource "yandex_vpc_gateway" "nat" {
  name = "nat-gw"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-rt"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}

locals {
  private_subnets = {
    private-a = { zone = "ru-central1-a", cidr = var.private_a_cidr }
    private-b = { zone = "ru-central1-b", cidr = var.private_b_cidr }
  }
}

resource "yandex_vpc_subnet" "private" {
  for_each       = local.private_subnets
  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [each.value.cidr]
  route_table_id = yandex_vpc_route_table.private_rt.id
}
