# Serverless Contact Form API (Terraform + GitHub Actions)

This repository deploys a fully‑serverless backend for a website contact form:

* **API Gateway** – `POST /contact`
* **AWS Lambda** – validates, stores, notifies
* **DynamoDB** – stores submissions
* **SES** – sends email notification
* IaC with **Terraform**, CI/CD via **GitHub Actions**.

---
`terraform/main.tf` wires up five reusable modules under `terraform/modules/*`.
