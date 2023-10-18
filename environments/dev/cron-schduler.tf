resource "google_cloud_scheduler_job" "cron_job" {
  name     = "my-cron-job"
  region = "us-central1"

  schedule = "*/10 * * * *"  # This schedule runs the job every 10 minutes

  pubsub_target {
    topic_name = google_pubsub_topic.my_topic.name
    data = base64encode("Hello, Pub/Sub!")  # Encode the data
  }

  retry_config {
    retry_count      = 3
    max_retry_duration = "3600s"
  }
}

resource "google_pubsub_topic" "my_topic" {
  name = "my-topic"
}

resource "google_pubsub_subscription" "my_subscription" {
  name   = "my-subscription"
  topic  = google_pubsub_topic.my_topic.name
  ack_deadline_seconds = 10
}