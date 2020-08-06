resource "helm_release" "nginx-ingress" {

  name  = "nginx"
  chart = "stable/nginx-ingress"
  namespace = var.namespace

}

variable "namespace" {
  default = "kube-system"
}
