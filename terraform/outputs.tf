output "api_endpoint" {
  description = "Invoke URL for POST /contact"
  value       = module.apigw.invoke_url
}
