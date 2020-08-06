resource "helm_release" "metrics-server" {

  name  = "metrics-server"
  chart = "stable/metrics-server"
  namespace = var.namespace

}

variable "namespace" {
  default = "kube-system"
}
