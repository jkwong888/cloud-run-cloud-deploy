
# create a workload identity pool
resource "google_iam_workload_identity_pool" "github" {
  project = module.ci_project.project_id
  workload_identity_pool_id = "github"
}

# create a github identity provider for github actions -- bind claims in the token to attributes
resource "google_iam_workload_identity_pool_provider" "github" {
  project = module.ci_project.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  attribute_mapping                  = {
    "google.subject" = "assertion.sub"
    "attribute.aud" = "assertion.aud"
    "attribute.actor" = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com/"
  }
}

# create an SA representing github actions
resource "google_service_account" "github_sa" {
  project = module.ci_project.project_id
  account_id = "github-actions"
}

# allow actions to impersonate github actions
resource "google_service_account_iam_member" "github_sa_wi" {
    service_account_id = google_service_account.github_sa.id
    role = "roles/iam.workloadIdentityUser"
    member = "principalSet://iam.googleapis.com/projects/${module.ci_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository_owner/jkwong888"
}

# allow github actions to create cloud deploy pipelines and releases
resource "google_project_iam_member" "github_actions_clouddeploy" {
    project = module.ci_project.project_id
    member = format("serviceAccount:%s", google_service_account.github_sa.email)
    role = "roles/clouddeploy.operator"
}

# allow github actions to create storage buckets (for intermediate artifacts)
resource "google_project_iam_member" "github_actions_storage_admin" {
    project = module.ci_project.project_id
    member = format("serviceAccount:%s", google_service_account.github_sa.email)
    role = "roles/storage.admin"
}

# allow github actions to create cloud run releases in dev (for PR workflow)
resource "google_project_iam_member" "github_actions_cloudrun_admin" {
    project = module.dev_project.project_id
    member = "serviceAccount:${google_service_account.github_sa.email}"
    role = "roles/run.admin"
}

# allow github actions to impersonate the cloud deploy service agent
resource "google_service_account_iam_member" "github_sa_cloud_deploy_agent_user" {
    service_account_id = google_service_account.cloud_deploy_agent_ci.id
    role = "roles/iam.serviceAccountUser"
    member = "serviceAccount:${google_service_account.github_sa.email}"
}

# allow github actions to impersonate the cloud run service account
resource "google_service_account_iam_member" "github_sa_cloud_run_dev_user" {
    service_account_id = google_service_account.run_sa_dev.id
    role = "roles/iam.serviceAccountUser"
    member = "serviceAccount:${google_service_account.github_sa.email}"
}