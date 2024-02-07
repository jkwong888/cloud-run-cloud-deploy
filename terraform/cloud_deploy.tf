resource "google_clouddeploy_delivery_pipeline" "backend" {
  location    = var.region
  name        = "backend"
  description = "basic description"
  project     = module.ci_project.project_id

  serial_pipeline {
    stages {
      profiles  = ["staging"]
      target_id = google_clouddeploy_target.staging.name
    }

    stages {
      profiles  = ["prod"]
      target_id = google_clouddeploy_target.prod.name
    }
  }

  provider    = google-beta
}

resource "google_clouddeploy_target" "staging" {
  location          = var.region
  name              = "staging-env"
  description       = "staging environment"

  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    execution_timeout = "3600s"
    service_account = google_service_account.cloud_deploy_agent_ci.email
  }

  run {
    location = "projects/${module.staging_project.project_id}/locations/${var.region}"
  }

  project           = module.ci_project.project_id
  require_approval  = false

  provider          = google-beta
}

resource "google_clouddeploy_target" "prod" {
  location          = var.region
  name              = "prod-env"
  description       = "prod environment"

  execution_configs {
    usages            = ["RENDER", "DEPLOY"]
    execution_timeout = "3600s"
    service_account = google_service_account.cloud_deploy_agent_ci.email
  }

  run {
    location = "projects/${module.prod_project.project_id}/locations/${var.region}"
  }

  project           = module.ci_project.project_id
  require_approval  = false

  provider          = google-beta
}