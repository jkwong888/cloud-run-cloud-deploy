resource "random_id" "random_suffix" {
  byte_length = 2
}

resource "google_folder" "parent" {
  display_name = format("%s-%s", var.service_project_id, random_id.random_suffix.hex)
  parent       = data.google_folder.parent_folder.id
}

data "google_folder" "parent_folder" {
    folder = format("folders/%s", var.parent_folder_id)
}

module "ci_project" {
  source = "git@github.com:jkwong888/tf-gcp-service-project.git"
  parent_folder_id = google_folder.parent.name
  #source = "../jkwng-tf-service-project-gke"

  billing_account_id          = var.billing_account_id
  shared_vpc_host_project_id  = var.shared_vpc_host_project_id
  shared_vpc_network          = var.shared_vpc_network
  project_id                  = var.billing_account_id != "" ? format("%s-ci-%s", var.service_project_id, random_id.random_suffix.hex) : var.service_project_id

  apis_to_enable              = [
    "compute.googleapis.com",
    "run.googleapis.com",
    "clouddeploy.googleapis.com",
    "iam.googleapis.com",
    "securetoken.googleapis.com",
    "iamcredentials.googleapis.com",

  ]

  subnets                     = []

  #subnet_users                = [google_service_account.gke_sa.email]
  skip_delete = false
}

module "dev_project" {
  source = "git@github.com:jkwong888/tf-gcp-service-project.git"
  parent_folder_id = google_folder.parent.name
  #source = "../jkwng-tf-service-project-gke"

  billing_account_id          = var.billing_account_id
  shared_vpc_host_project_id  = var.shared_vpc_host_project_id
  shared_vpc_network          = var.shared_vpc_network
  project_id                  = var.billing_account_id != "" ? format("%s-dev-%s", var.service_project_id, random_id.random_suffix.hex) : var.service_project_id

  apis_to_enable              = [
    "run.googleapis.com",
  ]

  subnets                     = []

  #subnet_users                = [google_service_account.gke_sa.email]
  skip_delete = false
}

module "staging_project" {
  source = "git@github.com:jkwong888/tf-gcp-service-project.git"
  parent_folder_id = google_folder.parent.name
  #source = "../jkwng-tf-service-project-gke"

  billing_account_id          = var.billing_account_id
  shared_vpc_host_project_id  = var.shared_vpc_host_project_id
  shared_vpc_network          = var.shared_vpc_network
  project_id                  = var.billing_account_id != "" ? format("%s-stg-%s", var.service_project_id, random_id.random_suffix.hex) : var.service_project_id

  apis_to_enable              = [
    "run.googleapis.com",
  ]

  subnets                     = []

  #subnet_users                = [google_service_account.gke_sa.email]
  skip_delete = false
}

module "prod_project" {
  source = "git@github.com:jkwong888/tf-gcp-service-project.git"
  #source = "../jkwng-tf-service-project-gke"
  parent_folder_id = google_folder.parent.name

  billing_account_id          = var.billing_account_id
  shared_vpc_host_project_id  = var.shared_vpc_host_project_id
  shared_vpc_network          = var.shared_vpc_network
  project_id                  = var.billing_account_id != "" ? format("%s-prd-%s", var.service_project_id, random_id.random_suffix.hex) : var.service_project_id

  apis_to_enable              = [
    "run.googleapis.com",
  ]


  subnets                     = []

  #subnet_users                = [google_service_account.gke_sa.email]
  skip_delete = false
}