resource "helm_release" "logging" {

  name  = "logging"
  chart = "../helmcharts/logging"
  namespace = var.namespace

  set {
    name = "namespace"
    value = var.namespace
  }

  set {
    name = "elasticsearch.replicaCount"
    value = var.elasticReplicaCount
  }

  set {
    name = "kibana.replicaCount"
    value = var.kibanaReplicaCount
  }
}