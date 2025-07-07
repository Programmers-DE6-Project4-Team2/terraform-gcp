# Cloud Composer Environment
resource "google_composer_environment" "de6_2ez_airflow" {
  name   = "de6-2ez-airflow"
  region = var.region
  project = var.project_id

  config {
    environment_size = "ENVIRONMENT_SIZE_SMALL"
    
    node_config {
      service_account = "terraform-admin@de6-2ez.iam.gserviceaccount.com"
      composer_internal_ipv4_cidr_block = "100.64.128.0/20"
      
      ip_allocation_policy {
        use_ip_aliases = false
      }
    }

    software_config {
      image_version = "composer-3-airflow-2.10.5-build.8"
      web_server_plugins_mode = "ENABLED"
      
      cloud_data_lineage_integration {
        enabled = false
      }
    }

    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 2.0
        storage_gb = 1.0
        count      = 1
      }

      web_server {
        cpu        = 1.0
        memory_gb  = 2.0
        storage_gb = 1.0
      }

      worker {
        cpu        = 0.5
        memory_gb  = 2.0
        storage_gb = 10.0
        min_count  = 1
        max_count  = 3
      }

      triggerer {
        count     = 1
        cpu       = 0.5
        memory_gb = 1.0
      }

      dag_processor {
        count      = 1
        cpu        = 1.0
        memory_gb  = 4.0
        storage_gb = 1.0
      }
    }

    data_retention_config {
      airflow_metadata_retention_config {
        retention_mode = "RETENTION_MODE_ENABLED"
        retention_days = 60
      }
    }

    web_server_network_access_control {
      allowed_ip_range {
        value = "0.0.0.0/0"
        description = "Allows access from all IPv4 addresses (default value)"
      }
      
      allowed_ip_range {
        value = "::0/0"
        description = "Allows access from all IPv6 addresses (default value)"
      }
    }
  }
}

# Enable Composer API
resource "google_project_service" "composer_api" {
  service = "composer.googleapis.com"
}