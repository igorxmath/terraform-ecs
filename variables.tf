variable "region" {
  type = string
}

variable "env_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "db_name" {
  type = string
  sensitive = true
}

variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "ipv4_cloudflare" {
  type = list(string)
}

variable "ipv6_cloudflare" {
  type = list(string)
}