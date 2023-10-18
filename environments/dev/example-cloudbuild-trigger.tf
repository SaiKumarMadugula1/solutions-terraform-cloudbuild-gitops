resource "google_cloudbuild_trigger" "my_trigger" {
  name     = "my-trigger"
  project  = "iac-project-397409"
  description = "Trigger for Cloud Build"

  trigger_template {
    branch_name {
      branch_name = "dev"
    }
    repo_name {
      repo_name = "SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops (GitHub App)"
    }
  }

  build {
    name = "gcr.io/cloud-builders/gcloud"
    args = ["builds", "submit", ".", "--config=cloudbuild.yaml"]
    #dir  = "cloudbuild"
  }

    substitutions = {
      _CLOUD_PUBSUB_TOPIC = "projects/iac-project-397409/topics/createschduler"
    }
  }