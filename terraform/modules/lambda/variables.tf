variable "function_name" {
  type        = string
  description = "The name of the AWS Lambda function to be created or managed."
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role that the Lambda function will assume during execution."
}

variable "handler_file" {
  type        = string
  description = "The file name and path of the Lambda function handler, typically in the format 'file_name.function_handler'."
}

variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table that the Lambda function will interact with."
}

variable "from_address" {
  type        = string
  description = "The verified SES email address used as the sender (FROM) address for outgoing emails."
}

variable "alert_address" {
  type        = string
  description = "The verified SES email address that will receive alerts or contact form submissions."
}
