import json, os, uuid, boto3, datetime

dynamodb     = boto3.resource("dynamodb")
ses          = boto3.client("ses")
TABLE_NAME   = os.environ["TABLE_NAME"]
NOTIFY_EMAIL = os.environ["NOTIFY_EMAIL"]

def lambda_handler(event, _ctx):
    body = json.loads(event.get("body", "{}"))
    name, email, message = body.get("name"), body.get("email"), body.get("message")

    if not all([name, email, message]):
        return {"statusCode": 400, "body": json.dumps({"error": "Invalid payload"})}

    table = dynamodb.Table(TABLE_NAME)
    item = {
        "id": str(uuid.uuid4()),
        "name": name,
        "email": email,
        "message": message,
        "created_at": datetime.datetime.utcnow().isoformat() + "Z"
    }
    table.put_item(Item=item)

    ses.send_email(
        Source=NOTIFY_EMAIL,
        Destination={"ToAddresses": [NOTIFY_EMAIL]},
        Message={
            "Subject": {"Data": f"New contact from {name}"},
            "Body": {"Text": {"Data": json.dumps(item, indent=2)}}
        }
    )
    return {"statusCode": 200, "body": json.dumps({"status": "ok"})}
