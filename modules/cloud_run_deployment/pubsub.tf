resource "google_storage_notification" "upload_image_notification" {
    bucket         = google_storage_bucket.images_private_bucket.name
    payload_format = "JSON_API_V1"
    topic          = google_pubsub_topic.upload_image_topic.id
    event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
    custom_attributes = {
        action = "analyze"
    }
    depends_on = [google_pubsub_topic_iam_binding.binding]
}

resource "google_pubsub_topic" "upload_image_topic" {
    project = var.project_id
    name = "${var.env}-upload-image-topic"
}

resource "google_pubsub_subscription" "upload_image_subscription" {
    project = var.project_id
    name  = "${var.env}-upload-image-subscription"
    topic = google_pubsub_topic.upload_image_topic.name

    ack_deadline_seconds = 20

    push_config {
        oidc_token {
            service_account_email = google_service_account.cloudrun_pubsub_invoker.email
        }
        push_endpoint = "${google_cloud_run_service.containers[1].status[0].url}/validate"
        attributes = {
            x-goog-version = "v1"
        }
    }
    depends_on = [
      google_cloud_run_service.containers
    ]

}