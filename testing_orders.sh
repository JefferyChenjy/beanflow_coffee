aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10005",
    "store": "SG-PL",
    "items": [
      {
        "name": "Coffee O Kosong (hot)",
        "quantity": 2
      },
      {
        "name": "Kaya Toast",
        "quantity": 4
      }
    ],
    "total": 10
  }' \
  --region us-east-1

aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10006",
    "store": "SG-OR",
    "items": [
      {
        "name": "Iced Americano",
        "quantity": 1
      },
      {
        "name": "Butter Croissant",
        "quantity": 2
      }
    ],
    "total": 12.50
  }' \
  --region us-east-1

  aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10007",
    "store": "SG-MB",
    "items": [
      {
        "name": "Matcha Latte",
        "quantity": 3
      },
      {
        "name": "Earl Grey Muffin",
        "quantity": 3
      }
    ],
    "total": 27.00
  }' \
  --region us-east-1

  aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10008",
    "store": "SG-JE",
    "items": [
      {
        "name": "Kopi C (hot)",
        "quantity": 4
      },
      {
        "name": "Soft Boiled Eggs (set)",
        "quantity": 2
      },
      {
        "name": "Kaya Toast",
        "quantity": 2
      }
    ],
    "total": 16.00
  }' \
  --region us-east-1

  aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10009",
    "store": "SG-TP",
    "items": [
      {
        "name": "Cold Brew Coffee",
        "quantity": 2
      },
      {
        "name": "Ham & Cheese Bagel",
        "quantity": 1
      }
    ],
    "total": 15.50
  }' \
  --region us-east-1

  aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10010",
    "store": "SG-PL",
    "items": [
      {
        "name": "Flat White",
        "quantity": 2
      },
      {
        "name": "Chocolate Brownie",
        "quantity": 1
      },
      {
        "name": "Almond Croissant",
        "quantity": 1
      }
    ],
    "total": 21.00
  }' \
  --region us-east-1


