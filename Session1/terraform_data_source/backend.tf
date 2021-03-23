terraform {
  backend "s3" {
    bucket = "terraform-state-file-asel"
    key    = "tfstate/data-source.tfstate"
    region = "us-east-1"
  }
}