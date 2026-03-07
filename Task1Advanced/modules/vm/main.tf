# Получаем последний образ из указанного семейства
data "yandex_compute_image" "this" {
  family = var.image_family
}

# Создаём загрузочный диск
resource "yandex_compute_disk" "this" {
  name     = "${var.vm_name}-disk"
  type     = var.disk_type
  zone     = var.zone
  image_id = data.yandex_compute_image.this.image_id
  size     = var.disk_size
}

# Создаём виртуальную машину
resource "yandex_compute_instance" "this" {
  name = var.vm_name
  zone = var.zone

  resources {
    cores  = var.cores
    memory = var.memory
  }

  boot_disk {
    disk_id = yandex_compute_disk.this.id
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"   # пользователь ubuntu
  }
}