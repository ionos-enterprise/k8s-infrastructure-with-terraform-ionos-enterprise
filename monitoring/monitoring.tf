resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "monitoring" {

  depends_on = [ kubernetes_namespace.monitoring-namespace ]
  name  = "prometheus"
  chart = "stable/prometheus"
  namespace = var.namespace

  set {
    name = "pushgateway.enabled"
    value = false
  }

  set {
    name = "forceNamespace"
    value = var.namespace
  }

  set {
    name = "kube-state-metrics.namespaceOverride"
    value = var.namespace
  }

  set {
    name = "server.alertmanagers[0].static_configs[0].targets[0]"
    value = "prometheus-alertmanager"
  }
}

resource "kubernetes_secret" "prometheus-grafana-datasource" {
  depends_on = [ kubernetes_namespace.monitoring-namespace ]
  metadata {
    name = "prometheus-grafana-datasource"
    namespace = var.namespace
    labels = {
      grafana_datasource = "1"
    }
  }
  data = {
    "datasource.yaml" = file("${path.module}/datasource.yaml")
  }
}

resource "helm_release" "grafana" {

  depends_on = [
    kubernetes_namespace.monitoring-namespace,
    kubernetes_secret.prometheus-grafana-datasource
  ]
  name  = "grafana"
  chart = "stable/grafana"
  namespace = var.namespace

  set {
    name = "sidecar.datasources.enabled"
    value = true
  }

  set {
    name = "namespaceOverride"
    value = var.namespace
  }

  set {
    name = "persistence.enabled"
    value = true
  }

  set {
    name = "persistence.size"
    value = "5Gi"
  }
}
