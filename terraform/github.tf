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

