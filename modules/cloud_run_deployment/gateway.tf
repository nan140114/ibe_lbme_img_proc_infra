resource "google_api_gateway_api" "images_api" {
  provider = google-beta
  api_id = "${var.env}-image-api"
}

resource "google_api_gateway_api_config" "images_api_cfg" {
    provider = google-beta
    api = google_api_gateway_api.images_api.api_id
    api_config_id_prefix = "${var.env}-image-api-config"
    openapi_documents {
        document {
            path = "spec.yaml"
            contents = textencodebase64(templatefile("${path.module}/templates/openapi.tftpl", {
                image_api_container_url = google_cloud_run_service.containers[0].status[0].url
                env = var.env
            }),"UTF-8")
    }
    }
    lifecycle {
        create_before_destroy = true
    }
    depends_on = [
         google_cloud_run_service.containers
    ]
}

resource "google_api_gateway_gateway" "images_api_gw" {
    provider   = google-beta
    region     = var.region

    api_config   = google_api_gateway_api_config.images_api_cfg.id

    gateway_id   = "${var.env}-api-gateway"
    display_name = "Images gateway "

    depends_on = [google_api_gateway_api_config.images_api_cfg]
}