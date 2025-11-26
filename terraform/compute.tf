
data "yandex_compute_image" "ubuntu" { family = "ubuntu-22-04-lts" }
locals { preemptible = true }

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores=2 memory=2 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=10 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.public-a.id nat=true security_group_ids=[yandex_vpc_security_group.bastion.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}

resource "yandex_compute_instance" "web1" {
  name        = "web-1"
  hostname    = "web-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores=2 memory=2 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=10 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.private-a.id security_group_ids=[yandex_vpc_security_group.web.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}

resource "yandex_compute_instance" "web2" {
  name        = "web-2"
  hostname    = "web-2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"
  resources { cores=2 memory=2 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=10 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.private-b.id security_group_ids=[yandex_vpc_security_group.web.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}

resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix-1"
  hostname    = "zabbix-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores=2 memory=4 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=10 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.public-a.id nat=true security_group_ids=[yandex_vpc_security_group.zabbix.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}

resource "yandex_compute_instance" "elastic" {
  name        = "elastic-1"
  hostname    = "elastic-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores=2 memory=4 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=20 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.private-a.id security_group_ids=[yandex_vpc_security_group.elastic.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana-1"
  hostname    = "kibana-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  resources { cores=2 memory=2 core_fraction=20 }
  boot_disk { initialize_params { image_id=data.yandex_compute_image.ubuntu.id size=10 type="network-hdd" } }
  network_interface { subnet_id=yandex_vpc_subnet.public-a.id nat=true security_group_ids=[yandex_vpc_security_group.kibana.id] }
  metadata = { ssh-keys = "ubuntu:${var.public_ssh_key}" }
  scheduling_policy { preemptible = local.preemptible }
}
