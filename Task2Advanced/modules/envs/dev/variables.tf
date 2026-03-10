# Переменные для аутентификации
variable "access_key" {
  description = "Static access key for Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Static secret key for Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "yandex_cloud_id" {
  description = "Идентификатор облака"
  type        = string
}

variable "yandex_folder_id" {
  description = "Идентификатор каталога"
  type        = string
}

# Переменные для настройки ВМ
variable "vm_name" {
  description = "Имя ВМ"
  type        = string
}

variable "cores" {
  description = "Количество ядер CPU"
  type        = number
}

variable "memory" {
  description = "Объём RAM (ГБ)"
  type        = number
}

variable "disk_size" {
  description = "Размер диска (ГБ)"
  type        = number
}

variable "disk_type" {
  description = "Тип диска"
  type        = string
  default     = "network-ssd"
}

variable "subnet_id" {
  description = "ID подсети"
  type        = string
}

variable "ssh_key_path" {
  description = "Путь к файлу с открытым SSH-ключом"
  type        = string
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "image_family" {
  description = "Семейство образа"
  type        = string
  default     = "ubuntu-2204-lts"
}