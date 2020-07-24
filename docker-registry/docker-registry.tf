resource "kubernetes_namespace" "docker-registry" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "docker-registry-config" {
  metadata {
    name = "docker-registry-config"
    namespace = var.namespace
  }
  data = {
    "config.yml" = file("${path.module}/config.yml")
  }
}

resource "kubernetes_secret" "docker-registry-secret" {
  metadata {
    name = "docker-registry-secret"
    namespace = var.namespace
  }

  data = {
    "HTPASSWD" = "${var.docker-registry-username}:${var.docker-registry-password-encrypted}"
  }
}

resource "kubernetes_secret" "docker-registry-dockerconfig" {
  metadata {
    name = "docker-registry-dockerconfig"
    namespace = var.namespace
  }

  data = {
    ".dockerconfigjson" = "{\"auths\":{\"${var.docker-registry-domain}\":{\"username\":\"${var.docker-registry-username}\",\"password\":\"${var.docker-registry-password}\"}}}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_deployment" "docker-registry" {
  metadata {
    name = var.namespace
    namespace = var.namespace
    labels = {
      app = "docker-registry"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "docker-registry"
      }
    }

    template {
      metadata {
        labels = {
          app = "docker-registry"
        }
      }
      spec {
        volume {
          name = "config"
          config_map {
            name = "docker-registry-config"
          }
        }
        volume {
          name = "htpasswd"
          secret {
            secret_name = "docker-registry-secret"
            items {
              key = "HTPASSWD"
              path = "htpasswd"
            }
          }
        }
        volume {
          name = "storage"
          empty_dir {}
        }
        container {
          name = "docker-registry"
          image = "registry:2.6.2"
          volume_mount {
            name = "config"
            mount_path = "/etc/docker/registry"
            read_only = true
          }
          volume_mount {
            name = "htpasswd"
            mount_path = "/auth"
            read_only = true
          }
          volume_mount {
            name = "storage"
            mount_path = "/var/lib/registry"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "docker-registry" {
  metadata {
    name = "docker-registry"
    namespace = var.namespace
  }
  spec {
    port {
      name = "http"
      port = "5000"
      protocol = "TCP"
      target_port = "5000"
    }
    selector = {
      app = "docker-registry"
    }
  }
}

resource "kubernetes_ingress" "docker-registry" {
  metadata {
    name = "docker-registry"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "0"
    }
  }
  spec {
    tls {
      hosts = [var.docker-registry-domain]
      secret_name = var.docker-registry-cert
    }
    rule {
      host = var.docker-registry-domain
      http {
        path {
          backend {
            service_name = "docker-registry"
            service_port = "5000"
          }
        }
      }
    }
  }
}
