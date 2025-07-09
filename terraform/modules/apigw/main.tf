# ------------------------------------------------------------
# API Gateway REST API
# ------------------------------------------------------------
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = var.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# ------------------------------------------------------------
# Resource for /contact path
# ------------------------------------------------------------
resource "aws_api_gateway_resource" "contact" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "contact"
}

# ------------------------------------------------------------
# Method for GET on /contact
# ------------------------------------------------------------
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.contact.id
  http_method   = "POST"
  authorization = "NONE"
}

# ------------------------------------------------------------
# Lambda Integration for GET method
# ------------------------------------------------------------
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.contact.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}

# ------------------------------------------------------------
# Deployment
# ------------------------------------------------------------
resource "aws_api_gateway_deployment" "this" {
  depends_on = [aws_api_gateway_integration.lambda_integration]

  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.body,
      aws_api_gateway_integration.lambda_integration.uri,
      aws_api_gateway_method.get_method
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------
# Stage
# ------------------------------------------------------------
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
  description   = var.stage_description
  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn != null ? [1] : []
    content {
      destination_arn = var.access_log_destination_arn
      format          = var.access_log_format
    }
  }

  tags = var.tags
}
