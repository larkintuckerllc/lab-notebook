provider "kubernetes" {
}

resource "kubernetes_service" "this" {
  metadata {
    labels = {
      release = var.release
    }
    name = var.app
  }
  spec {
    port {
      port = 80
    }
    selector = {
      app = var.app
    }
  }
}

resource "kubernetes_deployment" "this" {
  depends_on = [kubernetes_service.this]
  metadata {
    labels = {
      release = var.release
    }
    name = var.app
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = var.app
      }
    }
    template {
      metadata {
        labels = {
          app     = var.app
          release = var.release
        }
      }
      spec {
        container {
          image = "localhost:32000/api"
          name = "app"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
