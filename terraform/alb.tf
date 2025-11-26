
resource "yandex_alb_target_group" "web" {
  name = "${var.env}-web-tg"
  target { subnet_id=yandex_vpc_subnet.private-a.id ip_address=yandex_compute_instance.web1.network_interface[0].ip_address }
  target { subnet_id=yandex_vpc_subnet.private-b.id ip_address=yandex_compute_instance.web2.network_interface[0].ip_address }
}

resource "yandex_alb_backend_group" "web" {
  name = "${var.env}-web-bg"
  http_backend {
    name = "web"
    port = 80
    target_group_ids = [yandex_alb_target_group.web.id]
    healthcheck {
      http_healthcheck { path="/" }
      interval="2s" timeout="1s" healthy_threshold=3 unhealthy_threshold=3
    }
  }
}

resource "yandex_alb_http_router" "web" { name = "${var.env}-web-router" }

resource "yandex_alb_virtual_host" "web" {
  name = "${var.env}-web-vh"
  http_router_id = yandex_alb_http_router.web.id
  route { name="root" http_route { http_route_action { backend_group_id = yandex_alb_backend_group.web.id } } }
}

resource "yandex_alb_load_balancer" "web" {
  name       = "${var.env}-web-alb"
  network_id = yandex_vpc_network.main.id
  type       = "external"
  allocation_policy {
    location { zone_id="ru-central1-a" subnet_id=yandex_vpc_subnet.public-a.id }
    location { zone_id="ru-central1-b" subnet_id=yandex_vpc_subnet.public-b.id }
  }
  listener {
    name = "http"
    endpoint { address { external_ipv4_address {} } ports=[80] }
    http { handler { http_router_id = yandex_alb_http_router.web.id } }
  }
  security_group_ids = [yandex_vpc_security_group.alb.id]
}
