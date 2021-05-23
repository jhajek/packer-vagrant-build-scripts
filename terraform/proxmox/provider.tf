terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
#  pm_user         = var.pm_user
#  pm_password     = var.pm_password
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_log_enable = var.pm_log_enable
  pm_log_file = var.pm_log_file
  pm_timeout = var.pm_timeout
  pm_parallel = var.pm_parallel
  pm_log_levels = var.pm_log_levels
}