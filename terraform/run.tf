resource "google_service_account" "run_sa_dev" {
    project = module.dev_project.project_id
    account_id = "myapp-sa"
}

resource "google_service_account" "run_sa_staging" {
    project = module.staging_project.project_id
    account_id = "myapp-sa"
}

resource "google_service_account" "run_sa_prod" {
    project = module.prod_project.project_id
    account_id = "myapp-sa"
}

resource "google_cloud_run_v2_service" "myapp_staging" {
  project  = module.staging_project.project_id
  name     = "myapp-${random_id.random_suffix.hex}"
  location = var.region

  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    scaling {
      max_instance_count = 1
    }
    containers {
      image = "nginx:latest"
      ports { 
        container_port = 80
      }
    }
    service_account = google_service_account.run_sa_staging.email
    execution_environment  = "EXECUTION_ENVIRONMENT_GEN2"
  }
      traffic {
        type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
        percent = 100
      }

}

resource "google_cloud_run_v2_service" "myapp_prod" {
  project  = module.prod_project.project_id
  name     = "myapp-${random_id.random_suffix.hex}"
  location = var.region

  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    scaling {
      max_instance_count = 1
    }
    containers {
      image = "nginx:latest"
      ports { 
        container_port = 80
      }
    }
    service_account = google_service_account.run_sa_prod.email
    execution_environment  = "EXECUTION_ENVIRONMENT_GEN2"
  }
      traffic {
        type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
        percent = 100
      }

}