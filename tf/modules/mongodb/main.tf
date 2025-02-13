resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = "default"
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest"  # You can specify a version like "mongo:4.4"

          env {
            name  = "MONGO_INITDB_ROOT_USERNAME"
            value = "rootuser"
          }

          env {
            name  = "MONGO_INITDB_ROOT_PASSWORD"
            value = "rootpassword"
          }

          volume_mount {
            name      = "mongodb-data"
            mount_path = "/data/db"
          }
        }

        volume {
          name = "mongodb-data"
          persistent_volume_claim {
            claim_name = "mongodb-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb-nodeport-svc" {
  metadata {
    name      = "mongodb-nodeport-svc"
    namespace = "default"
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
      node_port   = 32000
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_persistent_volume_claim" "mongodb" {
  metadata {
    name      = "mongodb-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
