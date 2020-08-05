resource "kubernetes_namespace" "certmanager-namespace" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name  = "cert-manager"
  chart = "jetstack/cert-manager "
  namespace = "cert-manager"
  version = "v0.15.1"
}

resource "helm_release" "docker-registry-certs" {
  name  = "docker-registry-certs"
  chart = "../helmcharts/docker-registry-cert"
  namespace = "docker-registry"
  depends_on = [
    kubernetes_namespace.docker-registry
  ]
  set {
    name = "domain"
    value = var.docker-registry-domain
  }

  set {
    name = "certName"
    value = var.docker-registry-cert
  }

  set {
    name = "email"
    value = var.acme-email
  }

}
