locals {
  disk_ids = toset(concat(
    [yandex_compute_instance.bastion.boot_disk[0].disk_id],
    [for i in yandex_compute_instance.web : i.boot_disk[0].disk_id],
    [yandex_compute_instance.zabbix.boot_disk[0].disk_id],
    [yandex_compute_instance.elasticsearch.boot_disk[0].disk_id],
    [yandex_compute_instance.kibana.boot_disk[0].disk_id]
  ))
}

resource "yandex_compute_snapshot_schedule" "daily" {
  name             = "daily-7d"
  disk_ids         = local.disk_ids
  retention_period = "168h"

  schedule_policy {
    expression = "0 2 * * *"
  }

  snapshot_spec {
    description = "daily"
  }
}
