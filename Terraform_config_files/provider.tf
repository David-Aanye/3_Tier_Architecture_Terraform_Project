terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket       = "maabo-bucket-remote-tfstate"
    key          = "test/terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true


  }
}

