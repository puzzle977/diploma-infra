variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "sa_key_file" {
  type = string
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "public_cidr" {
  type    = string
  default = "10.10.0.0/24"
}

variable "private_a_cidr" {
  type    = string
  default = "10.20.0.0/24"
}

variable "private_b_cidr" {
  type    = string
  default = "10.30.0.0/24"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_pubkey_path" {
  type = string
}

variable "image_id" {
  type = string
}

variable "site_title" {
  type    = string
  default = "Diploma Site"
}

variable "alb_healthcheck_cidrs" {
  type = list(string)
}
