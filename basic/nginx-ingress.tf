resource "helm_release" "nginx-ingress" {

  name  = "nginx"
  chart = "stable/nginx-ingress"
  namespace = "kube-system"

}
