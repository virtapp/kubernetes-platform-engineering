

variable "k3s_version" {
  type    = string
  default = "v1.29.3+k3s1"
}

variable "node_role" {
  type    = string
  default = "server"
}

variable "disable_components" {
  type    = string
  default = "--disable traefik --disable local-storage"
}

variable "ingress_host" {
  description = "Hostname for ArgoCD ingress"
  type        = string
}


