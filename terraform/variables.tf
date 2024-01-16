variable "zone" {
  description = "zone"
}

variable "region" {
  description = "region"
}

variable "env" {
  description = "environment"
}

variable "project_id" {
  description = "project_id"
}

variable "project_number" {
  description = "project_number"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

