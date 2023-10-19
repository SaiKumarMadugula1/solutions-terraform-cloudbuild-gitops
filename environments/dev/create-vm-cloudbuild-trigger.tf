resource "google_cloudbuild_trigger" "createvm-cloudbuild-trigger" {
  location    = "global"
  name        = "createvm-trigger"
  description = "create vm pubsub build trigger"

  pubsub_config {
    topic = "projects/iac-project-397409/topics/createvm"
  }

  source_to_build {
    uri       = "https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    ref       = "refs/heads/dev"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "https://github.com/SaiKumarMadugula1/solutions-terraform-cloudbuild-gitops"
    revision  = "refs/heads/dev"
    repo_type = "GITHUB"
  }
}