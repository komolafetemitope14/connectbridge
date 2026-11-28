
resource "docker_network" "connectbridge" {
  name   = "${var.project_name}-${var.environment}"
  driver = var.network_driver

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "managed-by"
    value = "terraform"
  }
}

resource "docker_volume" "connectbridge_data" {
  name   = "${var.project_name}-${var.environment}-data"
  driver = var.volume_driver

  labels {
    label = "project"
    value = var.project_name
  }

  labels {
    label = "environment"
    value = var.environment
  }

  labels {
    label = "managed-by"
    value = "terraform"
  }
}
