resource "helm_release" "kubernetes-dashboard" {
  name  = "kubernetes-dashboard"
  chart = "kubernetes-dashboard/kubernetes-dashboard"
  namespace = var.namespace
}

resource "kubernetes_service_account" "admin-user" {
  metadata {
    name = "admin-user"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "admin-user" {
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = "admin-user"
    namespace = var.namespace
  }
}
