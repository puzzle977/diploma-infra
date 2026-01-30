output "bastion_public_ip" {
  value = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "zabbix_public_ip" {
  value = yandex_compute_instance.zabbix.network_interface[0].nat_ip_address
}

output "kibana_public_ip" {
  value = yandex_compute_instance.kibana.network_interface[0].nat_ip_address
}

output "alb_public_ip" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "web_fqdns" {
  value = [for k in keys(yandex_compute_instance.web) : "${k}.ru-central1.internal"]
}

output "elastic_fqdn" { value = "elastic.ru-central1.internal" }
output "zabbix_fqdn" { value = "zabbix.ru-central1.internal" }
output "kibana_fqdn" { value = "kibana.ru-central1.internal" }
output "bastion_fqdn" { value = "bastion.ru-central1.internal" }
