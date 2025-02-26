variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

variable "master_count" {
  type = number
  default = 1
}

variable "worker_count" {
  type = number
  default = 2
}
