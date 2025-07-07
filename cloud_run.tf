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

# Cloud Run service for Olive Young product scraping
resource "google_cloud_run_v2_service" "oliveyoung_product_scraper" {
  name     = "oliveyoung-product-scraper"
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.oliveyoung_scraper_sa.email
    
    timeout = "3600s"
    
    scaling {
      max_instance_count = 10
      min_instance_count = 0
    }

    containers {
      # 기존에 작동하는 이미지를 사용하거나 새 이미지 빌드
      # 현재는 placeholder 이미지 사용, 이후 실제 이미지로 교체
      image = "gcr.io/cloudrun/hello"
      
      resources {
        limits = {
          cpu    = "2"
          memory = "4Gi"
        }
        cpu_idle = true
        startup_cpu_boost = true
      }
      
      ports {
        container_port = 8080
      }
      
      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      
      env {
        name  = "GCS_BUCKET"
        value = "${var.project_id}-raw-data"
      }
      
      env {
        name  = "REGION"
        value = var.region
      }
      
      # Chrome/Selenium 관련 환경 변수
      env {
        name  = "DISPLAY"
        value = ":99"
      }
      
      env {
        name  = "CHROME_BIN"
        value = "/usr/bin/google-chrome"
      }
      
      env {
        name  = "CHROMEDRIVER_PATH"
        value = "/usr/local/bin/chromedriver"
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }

  depends_on = [
    google_artifact_registry_repository.oliveyoung_scrapers,
    google_project_service.cloud_run_api,
    google_project_service.artifact_registry_api
  ]
}

# Cloud Run service IAM policy - Allow unauthenticated access for Airflow calls
resource "google_cloud_run_service_iam_policy" "oliveyoung_scraper_policy" {
  location = google_cloud_run_v2_service.oliveyoung_product_scraper.location
  project  = google_cloud_run_v2_service.oliveyoung_product_scraper.project
  service  = google_cloud_run_v2_service.oliveyoung_product_scraper.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# IAM policy data for unauthenticated access
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

# Additional IAM permissions for Cloud Run services
resource "google_project_iam_member" "oliveyoung_scraper_cloud_run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.oliveyoung_scraper_sa.email}"
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