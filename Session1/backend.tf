terraform {
  backend "s3" {
    bucket = "terraform-state-file-asel"
    key    = "tfstate/webserver.tfstate"
    region = "us-east-1"
  }
}