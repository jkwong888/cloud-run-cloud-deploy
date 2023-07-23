resource "google_iam_workload_identity_pool" "github" {
  project = module.ci_project.project_id
  workload_identity_pool_id = "github"
}

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

resource "google_service_account" "github_sa" {
  project = module.ci_project.project_id
  account_id = "github-actions"
}

resource "google_service_account_iam_member" "github_sa_wi" {
    service_account_id = google_service_account.github_sa.id
    role = "roles/iam.workloadIdentityUser"
    member = "principalSet://iam.googleapis.com/projects/${module.ci_project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository_owner/jkwong888"
}

resource "google_project_iam_member" "github_actions_clouddeploy" {
    project = module.ci_project.project_id
    member = format("serviceAccount:%s", google_service_account.github_sa.email)
    role = "roles/clouddeploy.operator"
}

resource "google_project_iam_member" "github_actions_storage_admin" {
    project = module.ci_project.project_id
    member = format("serviceAccount:%s", google_service_account.github_sa.email)
    role = "roles/storage.admin"
}

resource "google_project_iam_member" "github_actions_cloudrun_admin" {
    project = module.dev_project.project_id
    member = format("serviceAccount:%s", google_service_account.github_sa.email)
    role = "roles/run.admin"
}

resource "google_service_account_iam_member" "github_sa_cloud_deploy_agent_user" {
    service_account_id = google_service_account.cloud_deploy_agent_ci.id
    role = "roles/iam.serviceAccountUser"
    member = "serviceAccount:${google_service_account.github_sa.email}"
}