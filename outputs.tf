output "de6_ez2_bucket_url" {
  value = "gs://${google_storage_bucket.de6_ez2.name}"
  description = "URL of the de6-ez2 GCS bucket"
}

output "raw_data_bucket_url" {
  value = "gs://${google_storage_bucket.raw_data.name}"
  description = "URL of the raw data GCS bucket"
}

output "oliveyoung_scraper_service_account_email" {
  value = google_service_account.oliveyoung_scraper_sa.email
  description = "Email of the Olive Young scraper service account"
}

output "artifact_registry_repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.oliveyoung_scrapers.repository_id}"
  description = "URL of the Artifact Registry repository"
}
