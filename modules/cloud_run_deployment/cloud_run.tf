# Deploy image to Cloud Run
resource "google_cloud_run_service" "containers" {
    count    = length(var.containers)
    project  = var.project_id
    name     = replace("${var.env}-${var.containers[count.index].name}", "_", "-")
    location = var.region
    template {
        spec {
            containers {
                image = "us.gcr.io/${var.containers[count.index].repository}/${var.containers[count.index].name}:${var.containers[count.index].version}"
                dynamic "env" {
                  for_each = var.containers[count.index].env.*
                  content {
                      name  = env.value.name
                      value = env.value.value
                  }
                }
            
            }
        }
        metadata {
            annotations = {
                "autoscaling.knative.dev/maxScale" = "10"
            }
        }
        
    }
    autogenerate_revision_name = true
    traffic {
        percent         = 100
        latest_revision = true
    }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${local.default_apigw_sa}",
      "serviceAccount:${local.default_pubsub_sa}"
    ]
  }
}

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "noauth" {
    count       = length(var.containers)
    location    = google_cloud_run_service.containers[count.index].location
    project     = google_cloud_run_service.containers[count.index].project
    service     = google_cloud_run_service.containers[count.index].name
    policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_cloud_run_service" "container_frontend" {
    project  = var.project_id
    name     = replace("${var.env}-${var.container_frontend.name}", "_", "-")
    location = var.region
    template {
        spec {
            containers {
                image = "us.gcr.io/${var.container_frontend.repository}/${var.container_frontend.name}:${var.container_frontend.version}"
                dynamic "env" {
                  for_each = var.container_frontend.env.*
                  content {
                      name  = env.value.name
                      value = env.value.value
                  }
                }
            }
        }
        metadata {
            annotations = {
                "autoscaling.knative.dev/maxScale" = "10"
            }
        }
    }
    autogenerate_revision_name = true
    traffic {
        percent         = 100
        latest_revision = true
    }
}

data "google_iam_policy" "ingress_noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_policy" "ingress_noauth" {
    count       = length(var.containers)
    location    = google_cloud_run_service.container_frontend.location
    project     = google_cloud_run_service.container_frontend.project
    service     = google_cloud_run_service.container_frontend.name
    policy_data = data.google_iam_policy.ingress_noauth.policy_data
}