terraform {
  backend "s3" {
    bucket = "hubbubhub"
    endpoints = {
        s3 = "http://localhost:9000"
    }
    key = "dev/hubbubhub.tfstate"

    access_key = "minioadmin"
    secret_key = "minioadmin"

    region = "main"
    skip_credentials_validation = true
    skip_requesting_account_id = true
    skip_metadata_api_check = true
    skip_region_validation = true
    use_path_style = true
  }

  required_providers {
    minio = {
      source = "aminueza/minio"
    }
  }
}

provider "kubernetes" {
  config_path    = "C:\\Users\\Matt\\.kube\\config"
  config_context = "docker-desktop"
}

provider "minio" {
  minio_server   = "http://localhost:9000"#"${var.S3_ENDPOINT}:9000/"
  minio_user     = "minioadmin" # var.S3_ACCESS_KEY
  minio_password = "minioadmin" # var.S3_SECRET_KEY
}

module "mongodb" {
  source    = "./modules/mongodb"
  namespace = "default"
}

module "postgresql" {
  source        = "ballj/postgresql/kubernetes"
  name          = "my_db"
  version       = "~> 1.2"
  namespace     = "default"
  object_prefix = "myapp-db"
  labels        = {
    "app.kubernetes.io/part-of" = "myapp"
  }
}
