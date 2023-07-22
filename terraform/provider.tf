terraform {
  backend "gcs" {
    bucket  = "jkwng-altostrat-com-tf-state"
    prefix = "jkwng-clouddeploy-dev"

  }
}

provider "google" {
#  credentials = file(local.credentials_file_path)
}

provider "google-beta" {
#  credentials = file(local.credentials_file_path)
}

provider "null" {
}

provider "random" {
}
