
resource "yandex_vpc_security_group" "bastion" {
  name       = "${var.env}-bastion-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=22 v4_cidr_blocks=["0.0.0.0/0"] }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}

resource "yandex_vpc_security_group" "alb" {
  name       = "${var.env}-alb-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=80  v4_cidr_blocks=["0.0.0.0/0"] }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}

resource "yandex_vpc_security_group" "zabbix" {
  name       = "${var.env}-zabbix-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=80    v4_cidr_blocks=["0.0.0.0/0"] }
  ingress { protocol="TCP" port=10051 v4_cidr_blocks=["10.10.0.0/16"] }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}

resource "yandex_vpc_security_group" "web" {
  name       = "${var.env}-web-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=80  security_group_id = yandex_vpc_security_group.alb.id }
  ingress { protocol="TCP" port=22  security_group_id = yandex_vpc_security_group.bastion.id }
  ingress { protocol="TCP" port=10050 security_group_id = yandex_vpc_security_group.zabbix.id }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}

resource "yandex_vpc_security_group" "elastic" {
  name       = "${var.env}-elastic-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=9200 v4_cidr_blocks=["10.10.0.0/16"] }
  ingress { protocol="TCP" port=22   security_group_id = yandex_vpc_security_group.bastion.id }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}

resource "yandex_vpc_security_group" "kibana" {
  name       = "${var.env}-kibana-sg"
  network_id = yandex_vpc_network.main.id
  ingress { protocol="TCP" port=5601 v4_cidr_blocks=["0.0.0.0/0"] }
  ingress { protocol="TCP" port=22   security_group_id = yandex_vpc_security_group.bastion.id }
  egress  { protocol="ANY" v4_cidr_blocks=["0.0.0.0/0"] }
}
