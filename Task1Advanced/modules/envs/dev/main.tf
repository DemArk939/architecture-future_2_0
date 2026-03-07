terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# Настройка провайдера Yandex Cloud
provider "yandex" {
  token     = var.account_key_file
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone      = var.zone
}

# Вызов модуля vm
module "vm" {
  source = "../../vm"

  vm_name        = var.vm_name
  cores          = var.cores
  memory         = var.memory
  disk_size      = var.disk_size
  disk_type      = var.disk_type
  subnet_id      = var.subnet_idF
  ssh_public_key = file(var.ssh_key_path)   # читаем содержимое ключа из файла
  zone           = var.zone
  image_family   = var.image_family
}