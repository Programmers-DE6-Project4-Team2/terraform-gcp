output "gcs_bucket_url" {
  value = "gs://${google_storage_bucket.raw_data.name}"
}
