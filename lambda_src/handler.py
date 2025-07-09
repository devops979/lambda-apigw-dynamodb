import json
import os
import uuid
import boto3
import datetime
import logging
from typing import Any, Dict

# ──────────────────────────────────────────────────────────
#  🔧 CONFIG & AWS CLIENTS
# ──────────────────────────────────────────────────────────
logging.basicConfig(level=logging.INFO, format="%(levelname)s  %(message)s")
log = logging.getLogger()

TABLE_NAME     = os.environ["TABLE_NAME"]
FROM_ADDRESS   = os.environ["FROM_ADDRESS"]      # verified; domain you own
ALERT_ADDRESS  = os.environ["ALERT_ADDRESS"]     # recipient (verified while in sandbox)

dynamodb = boto3.resource("dynamodb")
ses      = boto3.client("ses")                   # region auto-picked from Lambda env

table = dynamodb.Table(TABLE_NAME)

# ──────────────────────────────────────────────────────────
#  🛠️  HELPERS
# ──────────────────────────────────────────────────────────
def parse_body(event: Dict[str, Any]) -> Dict[str, Any]:
    """Return JSON body regardless of APIGW integration style."""
    if "body" in event:                  # proxy integration
        raw = event["body"] or "{}"
        if event.get("isBase64Encoded"):  # rare, but handle it
            import base64
            raw = base64.b64decode(raw).decode()
    else:                                # non-proxy
        raw = json.dumps(event)
    return json.loads(raw)


def build_email(name: str, email: str, message: str, item: Dict[str, str]):
    """Return (plain_text, html) body variants."""
    plain = (
        f"New contact form submission\n\n"
        f"Name   : {name}\n"
        f"Email  : {email}\n"
        f"Message: {message}\n\n"
        f"Full item:\n{json.dumps(item, indent=2)}"
    )

    html = f"""
    <html>
      <body>
        <h2>New contact form submission</h2>
        <table style="border-collapse:collapse">
          <tr><td><b>Name&nbsp;&nbsp;</b></td><td>{name}</td></tr>
          <tr><td><b>Email</b></td><td>{email}</td></tr>
          <tr><td><b>Message</b></td><td>{message}</td></tr>
        </table>
        <pre>{json.dumps(item, indent=2)}</pre>
      </body>
    </html>
    """
    return plain, html


# ──────────────────────────────────────────────────────────
#  🚀 LAMBDA HANDLER
# ──────────────────────────────────────────────────────────
def lambda_handler(event, _ctx):  # noqa: N802  (AWS signature)
    log.info("EVENT ► %s", json.dumps(event))

    # 1️⃣ Parse & validate JSON body
    try:
        body = parse_body(event)
    except Exception as exc:  # JSONDecodeError or b64 errors
        log.warning("JSON parse error: %s", exc)
        return {"statusCode": 400,
                "body": json.dumps({"error": "Invalid JSON"})}

    name    = body.get("name")
    email   = body.get("email")
    message = body.get("message")

    if not all([name, email, message]):
        return {"statusCode": 400,
                "body": json.dumps({"error": "name, email, message are required"})}

    # 2️⃣ Store item in DynamoDB
    item = {
        "id": str(uuid.uuid4()),
        "name": name,
        "email": email,
        "message": message,
        "created_at": datetime.datetime.utcnow()
                                    .isoformat(timespec="seconds") + "Z"
    }
    table.put_item(Item=item)
    log.info("DynamoDB PutItem OK – id=%s", item["id"])

    # 3️⃣ Build & send e-mail via SES
    text_body, html_body = build_email(name, email, message, item)

    try:
        resp = ses.send_email(
            Source=FROM_ADDRESS,                       # aligned w/ SPF+DKIM
            Destination={"ToAddresses": [ALERT_ADDRESS]},
            ReplyToAddresses=[email],                  # so “Reply” hits visitor
            Message={
                "Subject": {"Data": f"New contact from {name}"},
                "Body": {
                    "Text": {"Data": text_body},
                    "Html": {"Data": html_body}
                }
            }
        )
        log.info("SES MessageId: %s", resp["MessageId"])
    except ses.exceptions.MessageRejected as exc:
        log.error("SES MessageRejected: %s", exc)
        return {"statusCode": 500,
                "body": json.dumps({"error": "Email rejected by SES"})}
    except Exception as exc:
        log.error("SES unexpected error: %s", exc)
        return {"statusCode": 500,
                "body": json.dumps({"error": "Email send failed"})}

    # 4️⃣ Success response
    return {
        "statusCode": 201,
        "body": json.dumps({"status": "ok", "id": item["id"]})
    }
