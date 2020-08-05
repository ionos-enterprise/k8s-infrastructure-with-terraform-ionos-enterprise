resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "fluentd" {
  metadata {
    name = "fluentd"
    namespace = var.namespace
  }
  data = {
    "fluent.conf" = file("${path.module}/fluent.conf")
  }
}

resource "kubernetes_service_account" "fluentd" {
  metadata {
    name = "fluentd"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "fluentd" {
  metadata {
    name = "fluentd"
  }
  rule {
    verbs = [ "get", "list", "watch" ]
    resources = [ "pods", "namespaces" ]
    api_groups = [ "" ]
  }
}

resource "kubernetes_cluster_role_binding" "fluentd" {
  metadata {
    name = "fluentd"
  }
  subject {
    kind = "ServiceAccount"
    name = "fluentd"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "fluentd"
  }
}

resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name = "fluentd"
    namespace = var.namespace
    labels = {
      k8s-app: "fluentd-logging"
    }
  }
  spec {
    selector {
      match_labels = {
        k8s-app: "fluentd-logging"
      }
    }
    template {
      metadata {
        labels = {
          k8s-app: "fluentd-logging"
        }
      }
      spec {
        automount_service_account_token = true
        service_account_name = "fluentd"
        toleration {
          key = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
        container {
          name = "fluentd"
          image = "fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch"
          env {
            name = "FLUENT_ELASTICSEARCH_HOST"
            value = "elastic-es-http"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_PORT"
            value = "9200"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_SCHEME"
            value = "https"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_SSL_VERIFY"
            value = "false"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_SSL_VERSION"
            value = "TLSv1_2"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_USER"
            value = "elastic"
          }
          env {
            name = "FLUENT_ELASTICSEARCH_PASSWORD"
            value_from {
              secret_key_ref {
                key = "elastic"
                name = "elastic-es-elastic-user"
              }
            }
          }
          resources {
            limits {
              memory = "200Mi"
            }
            requests {
              cpu = "100m"
              memory = "200Mi"
            }
          }
          volume_mount {
            name = "varlog"
            mount_path = "/var/log"
          }
          volume_mount {
            name = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only = true
          }
          volume_mount {
            name = "fluentd-conf"
            mount_path = "/fluentd/etc/"
          }
        }
        termination_grace_period_seconds = 30
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
        volume {
          name = "fluentd-conf"
          config_map {
            name = "fluentd"
          }
        }
      }
    }
  }
}