resource "google_cloud_run_service" "iris-model" {
  name     = var.name
  location = var.location

  template {
    spec {
      containers {
        image = var.image
        ports {
          container_port = var.port
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.iris-model.location
  project     = google_cloud_run_service.iris-model.project
  service     = google_cloud_run_service.iris-model.name

  policy_data = data.google_iam_policy.noauth.policy_data
}