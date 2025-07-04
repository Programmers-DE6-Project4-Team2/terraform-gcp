output "gcs_bucket_url" {
  value = "gs://${google_storage_bucket.raw_data.name}"
}

output "dataproc_service_account_email" {
  value = google_service_account.dataproc_service_account.email
}

output "bigquery_datasets" {
  value = {
    raw_data  = google_bigquery_dataset.beauty_raw_data.dataset_id
    analytics = google_bigquery_dataset.beauty_analytics.dataset_id
    adhoc     = google_bigquery_dataset.beauty_adhoc.dataset_id
  }
}

output "airflow_vm_external_ip" {
  value = google_compute_instance.airflow_vm.network_interface[0].access_config[0].nat_ip
}

output "airflow_vm_internal_ip" {
  value = google_compute_instance.airflow_vm.network_interface[0].network_ip
}

output "airflow_web_url" {
  value = "http://${google_compute_instance.airflow_vm.network_interface[0].access_config[0].nat_ip}:8080"
}

output "flower_url" {
  value = "http://${google_compute_instance.airflow_vm.network_interface[0].access_config[0].nat_ip}:5555"
}
