terraform {
  backend "s3" {
    key    = "terraform-awskube/terraform.tfstate"
  }
}
