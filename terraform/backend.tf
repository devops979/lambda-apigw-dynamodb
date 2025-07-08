terraform {
  backend "s3" {
    bucket         = "YOUR_REMOTE_STATE_BUCKET"
    key            = "contact-form-api/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "YOUR_LOCK_TABLE"
    encrypt        = true
  }
}
