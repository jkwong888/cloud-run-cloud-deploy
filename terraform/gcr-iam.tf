data "google_project" "registry_project" {
    project_id = var.registry_project_id
}

# allow github actions to push to registry
resource "google_storage_bucket_iam_member" "github_push" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.admin"
    member  = format("serviceAccount:%s", google_service_account.github_sa.email)
}

# allow cloud build in CI project to push/pull images
resource "google_storage_bucket_iam_member" "ci_registry_writer" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.admin"
    member  = format("serviceAccount:%d@cloudbuild.gserviceaccount.com", module.ci_project.number)
}

# allow cloud run on dev to pull images
resource "google_storage_bucket_iam_member" "dev_registry_viewer" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.objectViewer"
    member  = format("serviceAccount:service-%d@serverless-robot-prod.iam.gserviceaccount.com", module.dev_project.number)
}

# allow cloud run on staging to pull images
resource "google_storage_bucket_iam_member" "staging_registry_viewer" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.objectViewer"
    member  = format("serviceAccount:service-%d@serverless-robot-prod.iam.gserviceaccount.com", module.staging_project.number)
}

# allow cloud run on prod to pull images
resource "google_storage_bucket_iam_member" "prod_registry_viewer" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.objectViewer"
    member  = format("serviceAccount:service-%d@serverless-robot-prod.iam.gserviceaccount.com", module.prod_project.number)
}

