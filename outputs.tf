output "de6_ez2_bucket_url" {
  value = "gs://${google_storage_bucket.de6_ez2.name}"
  description = "URL of the de6-ez2 GCS bucket"
}

output "oliveyoung_scraper_url" {
  value = google_cloud_run_v2_service.oliveyoung_product_scraper.uri
  description = "URL of the Olive Young scraper Cloud Run service"
}

output "oliveyoung_scraper_service_account_email" {
  value = google_service_account.oliveyoung_scraper_sa.email
  description = "Email of the Olive Young scraper service account"
}
