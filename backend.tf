terraform { 
  backend "s3" { 
    bucket = "testes3" 
    key    = "testes3.tfstate" 
    region = "us-east-1" 
  }
}