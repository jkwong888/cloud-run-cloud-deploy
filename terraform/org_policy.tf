resource "google_project_organization_policy" "allowAllDomainsIam" {
  project    = module.dev_project.project_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      all = true
    }
  }

}

resource "google_project_organization_policy" "allowAllDomainsIam_stg" {
  project    = module.staging_project.project_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      all = true
    }
  }

}

resource "google_project_organization_policy" "allowAllDomainsIam_prd" {
  project    = module.prod_project.project_id
  constraint = "constraints/iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      all = true
    }
  }

}