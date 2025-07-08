variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "contact_submissions"
}

variable "notify_email" {
  description = "Email address verified in SES to receive notifications"
  type        = string
}
