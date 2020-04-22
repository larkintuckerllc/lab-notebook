provider "kubernetes" {
}

resource "kubernetes_service" "this" {
  labels = {
    release = "a"
  }
  metadata {
    name = "api"
  }
  spec {
    selector = {
      app = "api"
    }
    port {
      port = 80
    }
  }
}
