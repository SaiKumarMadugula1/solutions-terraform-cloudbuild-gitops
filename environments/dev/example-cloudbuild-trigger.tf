resource "google_cloudbuild_trigger" "pubsub-config-trigger" {
  location    = "us-central1"
  name        = "pubsub-trigger"
  description = "test example pubsub build trigger"

  pubsub_config {
    topic = "projects/iac-project-397409/topics/createschduler"
  }

  source_to_build {
    uri       = "https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    ref       = "refs/heads/dev"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = ""https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    revision  = "refs/heads/dev"
    repo_type = "GITHUB"
  }

  substitutions = {
    _ACTION       = "$(body.message.data.action)"
  }

  filter = "_ACTION.matches('INSERT')"
}