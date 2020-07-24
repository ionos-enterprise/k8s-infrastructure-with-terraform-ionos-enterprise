resource "helm_release" "metrics-server" {

  name  = "metrics-server"
  chart = "stable/metrics-server"
  namespace = "kube-system"

}
