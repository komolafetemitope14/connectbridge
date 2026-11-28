
variable "project_name" {
  description = "Name of the ConnectBridge project"
  type        = string
  default     = "connectbridge"
}

variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "uat"], var.environment)
    error_message = "Environment must be dev, test or uat."
  }
}

variable "network_driver" {
  description = "Docker network driver"
  type        = string
  default     = "bridge"
}

variable "volume_driver" {
  description = "Docker persistent volume driver"
  type        = string
  default     = "local"
}
