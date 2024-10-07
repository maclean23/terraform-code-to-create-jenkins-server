terraform {
  backend "s3" {
    bucket = "learningbucket-app"
    region = "eu-west-2"
    key    = "jenkins-server/terraform.tfstate"
  }
}
