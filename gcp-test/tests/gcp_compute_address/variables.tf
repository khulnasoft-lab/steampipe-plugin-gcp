
variable "resource_name" {
  type        = string
  default     = "turbot-test-20200125-create-update"
  description = "Name of the resource used throughout the test."
}

variable "gcp_project" {
  type        = string
  default     = "parker-aaa"
  description = "GCP project used for the test."
}

variable "gcp_region" {
  type        = string
  default     = "us-east1"
  description = "GCP region used for the test."
}

variable "gcp_zone" {
  type    = string
  default = "us-east1-b"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

data "google_client_config" "current" {}

data "null_data_source" "resource" {
  inputs = {
    scope = "gcp://cloudresourcemanager.googleapis.com/projects/${data.google_client_config.current.project}"
  }
}

resource "google_compute_network" "named_test_resource" {
  name = var.resource_name
}

resource "google_compute_subnetwork" "named_test_resource" {
  name          = "${var.resource_name}-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.named_test_resource.id
}

resource "google_compute_address" "named_test_resource" {
  name         = var.resource_name
  description  = "Test address to validate integration test."
  subnetwork   = google_compute_subnetwork.named_test_resource.id
  address_type = "INTERNAL"
  address      = "10.0.42.42"
  region       = var.gcp_region
}

output "resource_aka" {
  value = "gcp://compute.googleapis.com/${google_compute_address.named_test_resource.id}"
}

output "resource_name" {
  value = var.resource_name
}

output "resource_id" {
  value = google_compute_address.named_test_resource.id
}

output "self_link" {
  value = google_compute_address.named_test_resource.self_link
}

output "network" {
  value = google_compute_network.named_test_resource.self_link
}

output "subnetwork" {
  value = google_compute_subnetwork.named_test_resource.self_link
}

output "project_id" {
  value = var.gcp_project
}
