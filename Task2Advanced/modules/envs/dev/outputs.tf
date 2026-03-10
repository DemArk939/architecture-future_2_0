output "vm_public_ip" {
  description = "Публичный IP созданной ВМ"
  value       = module.vm.external_ip
}

output "vm_id" {
  description = "ID созданной ВМ"
  value       = module.vm.instance_id
}