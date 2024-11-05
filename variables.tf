variable "aws_access_key" {
  description = "AWS Access Key"
  sensitive = true
}

variable "aws_secret_key" {
    description = "AWS Secret Key"
    sensitive = true
}

variable "digitalocean_token" {
  description = "DigitalOcean Token"
    sensitive = true
}

variable "aws_session_token" {
  description = "AWS Session Token"
  sensitive = true
}
