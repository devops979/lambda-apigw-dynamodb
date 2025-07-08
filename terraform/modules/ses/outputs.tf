output "identity_arn" {
  description = "The Amazon Resource Name (ARN) of the verified email identity in AWS SES, used for sending emails."
  value       =  aws_ses_email_identity.this.arn
}
