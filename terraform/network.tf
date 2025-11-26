
resource "yandex_vpc_network" "main" { name = "${var.env}-net" }

resource "yandex_vpc_subnet" "public-a" {
  name           = "${var.env}-public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_subnet" "public-b" {
  name           = "${var.env}-public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "private-a" {
  name           = "${var.env}-private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.10.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_vpc_subnet" "private-b" {
  name           = "${var.env}-private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.20.0/24"]
  route_table_id = yandex_vpc_route_table.private.id
}

resource "yandex_vpc_gateway" "nat" {
  name = "${var.env}-nat"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  name       = "${var.env}-private-rt"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}
