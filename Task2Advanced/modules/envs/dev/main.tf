terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  # Частичная конфигурация бэкенда – остальное в backend-dev.conf или backend-ci.conf
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region = "default-ru-central1-a"
    encrypt = true
  }
}

# Настройка провайдера
provider "yandex" {
  access_key = var.access_key
  secret_key = var.secret_key
  cloud_id   = var.yandex_cloud_id
  folder_id  = var.yandex_folder_id
  zone       = var.zone
}

module "vm" {
  source = "../../vm"

  vm_name        = var.vm_name
  cores          = var.cores
  memory         = var.memory
  disk_size      = var.disk_size
  disk_type      = var.disk_type
  subnet_id      = var.subnet_id
  ssh_public_key = file(var.ssh_key_path)
  zone           = var.zone
  image_family   = var.image_family
}