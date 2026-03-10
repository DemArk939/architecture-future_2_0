output "instance_id" {
  description = "ID созданной ВМ"
  value       = yandex_compute_instance.this.id
}

output "instance_name" {
  description = "Имя ВМ"
  value       = yandex_compute_instance.this.name
}

output "external_ip" {
  description = "Публичный IP-адрес ВМ"
  value       = yandex_compute_instance.this.network_interface[0].nat_ip_address
}

output "disk_id" {
  description = "ID созданного диска"
  value       = yandex_compute_disk.this.id
}