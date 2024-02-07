# create a service account that cloud deploy uses 
resource "google_service_account" "cloud_deploy_agent_ci" {
    project = module.ci_project.project_id
    account_id = "cloud-deploy-agent"
}

# allow cloud deploy service account to run cloud deploy jobs
resource "google_project_iam_member" "cloud_deploy_agent_ci_jobrunner" {
    project = module.ci_project.project_id
    member = format("serviceAccount:%s", google_service_account.cloud_deploy_agent_ci.email)
    role = "roles/clouddeploy.jobRunner"
}

# allow cloud deploy service account to create cloud run services in staging
resource "google_project_iam_member" "cloud_deploy_agent_ci_staging_run_developer" {
    project = module.staging_project.project_id
    member = format("serviceAccount:%s", google_service_account.cloud_deploy_agent_ci.email)
    role = "roles/run.developer"
}

# allow cloud deploy service account to create cloud run services in prod
resource "google_project_iam_member" "cloud_deploy_agent_ci_prod_run_developer" {
    project = module.prod_project.project_id
    member = format("serviceAccount:%s", google_service_account.cloud_deploy_agent_ci.email)
    role = "roles/run.developer"
}

# allow cloud deploy service account to impersonate cloud run service account in staging
resource "google_service_account_iam_member" "cloud_deploy_run_sa_stg" {
    service_account_id = google_service_account.run_sa_staging.id
    role = "roles/iam.serviceAccountUser"
    member = format("serviceAccount:%s", google_service_account.cloud_deploy_agent_ci.email)
}

# allow cloud deploy service account to impersonate cloud run service account in prod
resource "google_service_account_iam_member" "cloud_deploy_run_sa_prd" {
    service_account_id = google_service_account.run_sa_prod.id
    role = "roles/iam.serviceAccountUser"
    member = format("serviceAccount:%s", google_service_account.cloud_deploy_agent_ci.email)
}