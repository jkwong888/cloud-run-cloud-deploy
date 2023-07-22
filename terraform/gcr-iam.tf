data "google_project" "registry_project" {
    project_id = var.registry_project_id
}

# take the GKE SA and allow storage object browser on the image registry bucket
resource "google_storage_bucket_iam_member" "github_push" {
    bucket  = format("artifacts.%s.appspot.com", data.google_project.registry_project.project_id)
    role    = "roles/storage.admin"
    member  = format("serviceAccount:%s", google_service_account.github_sa.email)
}