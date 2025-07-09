############################################
# Global / commonly reused values
############################################
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "ap-south-1"
}
 
############################################
# Contact-form specific values
############################################
variable "table_name" {
  description = "Name of the DynamoDB table that stores contact submissions"
  type        = string
  default     = "contact_submissions"
}
 
variable "notify_email" {
  description = <<EOF
E-mail address that will:
  • be VERIFIED in Amazon SES
  • receive all contact-form notifications
EOF
  type = string  
  default = "devops979@gmail.com"
}
 
############################################
# API Gateway logging / tagging knobs
############################################
variable "access_log_destination_arn" {
  description = "ARN of the CloudWatch Logs log group for access logging"
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "Format string for access logs"
  type        = string
  default     = <<EOF
{ "requestId":"$context.requestId", "ip":"$context.identity.sourceIp", "caller":"$context.identity.caller", "user":"$context.identity.user", "requestTime":"$context.requestTime", "httpMethod":"$context.httpMethod", "resourcePath":"$context.resourcePath", "status":"$context.status", "protocol":"$context.protocol", "responseLength":"$context.responseLength" }
EOF
}
 
variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project      = "contact-form"
    Owner        = "dev-team"
  }
}
