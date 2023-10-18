resource "google_cloudbuild_trigger" "deletevm-cloudbuild-trigger" {
  location    = "global"
  name        = "deletevm-trigger"
  description = "test example pubsub build trigger"

  pubsub_config {
    topic = "projects/iac-project-397409/topics/deletevm"
  }

  source_to_build {
    uri       = "https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    ref       = "refs/heads/dev"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "delete-vm-cloudbuild.yaml"
    uri       = "https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    revision  = "refs/heads/dev"
    repo_type = "GITHUB"
  }

  substitutions = {
    _ACTION       = "$(body.message.data.action)"
  }

  filter = "_ACTION.matches('INSERT')"
}