# Cloud Run services for Olive Young scraping

# Service account for Cloud Run services
resource "google_service_account" "oliveyoung_scraper_sa" {
  account_id   = "oliveyoung-scraper"
  display_name = "Olive Young Scraper Service Account"
  description  = "Service account for Olive Young Cloud Run scraper"
}

# Grant necessary permissions to the service account
resource "google_project_iam_member" "oliveyoung_scraper_gcs" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.oliveyoung_scraper_sa.email}"
}

resource "google_project_iam_member" "oliveyoung_scraper_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.oliveyoung_scraper_sa.email}"
}

# Artifact Registry for storing container images
resource "google_artifact_registry_repository" "oliveyoung_scrapers" {
  location      = var.region
  repository_id = "oliveyoung-scrapers"
  description   = "Container images for Olive Young scraping services"
  format        = "DOCKER"
}

# Additional IAM permissions for Cloud Run services
resource "google_project_iam_member" "oliveyoung_scraper_cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.oliveyoung_scraper_sa.email}"
}

# Grant Cloud Run Service Agent permission to read from Container Registry
resource "google_project_iam_member" "cloud_run_service_agent_gcr" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:service-418107028708@serverless-robot-prod.iam.gserviceaccount.com"
}

# Enable required APIs
resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
}

resource "google_project_service" "artifact_registry_api" {
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "cloud_build_api" {
  service = "cloudbuild.googleapis.com"
}