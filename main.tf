# Storage buckets removed - managed manually to prevent data loss

# IAM bindings for project members - Storage Admin access
resource "google_project_iam_binding" "storage_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/storage.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Cloud Run Admin access
resource "google_project_iam_binding" "cloud_run_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/run.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Compute Admin access
resource "google_project_iam_binding" "compute_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/compute.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - BigQuery Admin access
resource "google_project_iam_binding" "bigquery_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/bigquery.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - IAM Admin access
resource "google_project_iam_binding" "iam_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}


# IAM bindings for project members - Artifact Registry Admin access
resource "google_project_iam_binding" "artifact_registry_admin" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Service Usage Consumer access
resource "google_project_iam_binding" "service_usage_consumer" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Cloud Build Editor access
resource "google_project_iam_binding" "cloud_build_editor" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/cloudbuild.builds.editor"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}

# IAM bindings for project members - Logging Viewer access (for Cloud Run job logs)
resource "google_project_iam_binding" "logging_viewer" {
  count   = length(var.project_members) > 0 ? 1 : 0
  project = var.project_id
  role    = "roles/logging.viewer"
  
  members = [
    for email in var.project_members : "user:${email}"
  ]
}
