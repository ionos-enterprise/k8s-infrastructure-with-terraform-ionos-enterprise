variable "docker-registry-domain" {
  default = ""
}

variable "ingress-enabled" {
  default = "false"
}

variable "acme-email" {
  default = ""
}

variable "docker-registry-username" {
  default = "admin"
}

variable "docker-registry-password" {
  default = "some-safe-password"
}

variable "docker-registry-password-encrypted" {
  default = ""
}

variable "docker-registry-cert" {
  default = "docker-registry-cert"
}

variable "namespace" {
  default = "docker-registry"
}