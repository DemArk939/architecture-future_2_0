# Данные для доступа к Yandex Cloud
account_key_file     = "authorized_key.json"  # Путь к файлу доступа к Yandex Cloud
yandex_cloud_id  = "b1gqa5o3fp5kdf4mv72c"     # ID облака
yandex_folder_id = "b1g4k4da20kb1non2nli"     # ID каталога

# Параметры ВМ
vm_name      = "stage-vm"
cores        = 2
memory       = 4
disk_size    = 20
disk_type    = "network-hdd"
subnet_id    = "e9btou1iee6h29vohl5o"         # ID подсети dev
ssh_key_path = "~/.ssh/id_rsa.pub"            # путь к вашему публичному ключу
zone         = "default-ru-central1-a"
image_family = "ubuntu-2204-lts"