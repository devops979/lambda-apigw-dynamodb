variable "api_name" {
  type        = string
  description = "The name of the API Gateway REST API."
}

variable "description" {
  type        = string
  description = "A brief description of the API Gateway REST API."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the API Gateway resources."
}

variable "lambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function to be integrated with API Gateway."
}

variable "aws_region" {
  type        = string
  description = "The AWS region where the resources are deployed."
}

variable "stage_name" {
  type        = string
  description = "The name of the deployment stage for the API Gateway."
}

variable "stage_description" {
  type        = string
  description = "A description for the API Gateway stage."
}

variable "access_log_destination_arn" {
  type        = string
  description = "The ARN of the destination for access logs (e.g., CloudWatch Log Group)."
  default     = null
}

variable "access_log_format" {
  type        = string
  description = "The format for access logs in API Gateway."
  default     = null
}
