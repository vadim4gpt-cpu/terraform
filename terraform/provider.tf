terraform {
  required_version = ">= 1.4.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.133.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "${path.module}/key.json"

  cloud_id  = "b1ghhd43ql6d1ilnnlhg"
  folder_id = "b1g39d772aj1tu8o1s58"
  zone      = "ru-central1-a"
}
