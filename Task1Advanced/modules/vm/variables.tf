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

variable "ssh_public_key" {
  description = "Содержимое открытого SSH-ключа (строка)"
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