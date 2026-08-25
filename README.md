# ☕ BeanFlow Coffee — AWS Event-Driven Microservices Demo

A hands-on AWS and Terraform demo based on the **Microservices Coffee Shop** scenario.

This project demonstrates how to build a loosely coupled, event-driven architecture using:

* **Terraform** — Infrastructure as Code
* **Amazon SNS** — Event fan-out
* **Amazon SQS** — Reliable message buffering
* **AWS Lambda** — Serverless event processing
* **Amazon CloudWatch** — Logging and monitoring
* **Discord / Slack Webhooks** — External business notifications

The architecture is designed to demonstrate the principles of **decoupling, asynchronous processing, fault tolerance, and infrastructure automation**.

---

## 📋 Business Scenario

### BeanFlow Coffee

BeanFlow Coffee is a fictional coffee shop chain with multiple stores across Singapore.

Customers can place orders through:

* Mobile application
* Self-service kiosk
* Website
* Delivery platforms

When a customer places an order, the application generates an `ORDER_CREATED` event.

For example:

```json
{
  "event_type": "ORDER_CREATED",
  "order_id": "ORD-10025",
  "store": "SG-ORCHARD",
  "items": [
    {
      "name": "Iced Latte",
      "quantity": 1
    },
    {
      "name": "Blueberry Muffin",
      "quantity": 1
    }
  ],
  "total": 12.50,
  "timestamp": "2026-08-10T18:00:00+08:00"
}
```

Different parts of the business need to react to the same event.

### Store Operations

The store team receives notifications through **Discord**.

### HQ Operations

The operations team receives notifications through **Slack**.

---

# 🏗️ Architecture

The architecture follows the AWS SNS/SQS fan-out pattern.

```text
                    ┌──────────────────────┐
                    │   BeanFlow Coffee    │
                    │    Order System      │
                    └──────────┬───────────┘
                               │
                               │ ORDER_CREATED
                               ▼
                    ┌──────────────────────┐
                    │     Amazon SNS       │
                    │   Order Event Topic  │
                    │                      │
                    │       FAN-OUT        │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
          ┌─────────────────┐   ┌─────────────────┐
          │   Amazon SQS    │   │   Amazon SQS    │
          │ Discord Queue   │   │  Slack Queue    │
          └────────┬────────┘   └────────┬────────┘
                   │                     │
                   └──────────┬──────────┘
                              │
                              ▼
                    ┌──────────────────────┐
                    │     AWS Lambda       │
                    │ Notification          │
                    │ Processor             │
                    └──────────┬───────────┘
                               │
                         ┌─────┴─────┐
                         │           │
                         ▼           ▼
                   ┌──────────┐ ┌──────────┐
                   │ Discord  │ │  Slack   │
                   │ Webhook  │ │ Webhook  │
                   └──────────┘ └──────────┘
```

---

# 💡 Why SNS + SQS?

A simple implementation might connect the order application directly to Discord and Slack:

```text
Order Application
       │
       ├──────────► Discord
       │
       └──────────► Slack
```

This creates tight coupling.

If Discord is unavailable:

```text
Order Application
       │
       └──────────► Discord ❌
```

The application is now dependent on an external notification service.

With SNS and SQS:

```text
Order Application
       │
       ▼
      SNS
       │
       ├────► Discord SQS ────► Lambda ────► Discord
       │
       └────► Slack SQS ──────► Lambda ────► Slack
```

The order application only needs to publish an event.

The downstream systems can process the event independently.

---

# 🎯 Key Architecture Benefits

## 1. Loose Coupling

The order application does not need to know:

* Who consumes the event
* How the event is processed
* Whether Discord is available
* Whether Slack is available

It only publishes an event to SNS.

---

## 2. Fan-Out

One event can be delivered to multiple consumers.

```text
                   SNS
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Discord Queue        Slack Queue
```

Adding another consumer does not require changing the order application.

For example:

```text
SNS
 │
 ├── Discord SQS
 ├── Slack SQS
 ├── Analytics SQS
 └── Fraud Detection SQS
```

---

## 3. Asynchronous Processing

The order application does not wait for Discord or Slack.

```text
Order
  │
  ▼
 SNS
  │
  ▼
Continue processing
```

The downstream systems process events asynchronously.

---

## 4. Fault Tolerance

If Discord is temporarily unavailable:

```text
SNS
 │
 ▼
Discord SQS
 │
 │  Message remains queued
 │
 X── Discord unavailable
```

The order event can remain in SQS until it can be processed successfully.

This prevents a temporary downstream failure from directly blocking the order application.

---

# 🛠️ Technologies

| Technology      | Purpose                      |
| --------------- | ---------------------------- |
| Terraform       | Infrastructure as Code       |
| AWS SNS         | Event publishing and fan-out |
| AWS SQS         | Message buffering            |
| AWS Lambda      | Event processing             |
| IAM             | Access control               |
| CloudWatch      | Lambda logging               |
| Discord Webhook | Store notification           |
| Slack Webhook   | HQ notification              |

---

# 📁 Project Structure

```text
beanflow-aws-demo/
│
├── terraform/
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── main.tf
│   ├── sns.tf
│   ├── sqs.tf
│   ├── iam.tf
│   ├── lambda.tf
│   └── terraform.tfvars
│
├── lambda/
│   └── index.mjs
│
├── scripts/
│   └── send-order.sh
│
├── .gitignore
└── README.md
```

---

# ⚙️ Prerequisites

Install the following:

### Terraform

```bash
terraform --version
```

Terraform 1.6+ is recommended.

### AWS CLI

```bash
aws --version
```

Verify your AWS credentials:

```bash
aws sts get-caller-identity
```

Example:

```json
{
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/demo-user"
}
```

---

# 🌏 AWS Region

The demo currently uses:

```text
us-east-1
```

To change the region, update:

```hcl
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
```

---

# 🚀 Deployment

## 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd beanflow-aws-demo
```

---

## 2. Initialize Terraform

```bash
cd terraform
terraform init
```

---

## 3. Format Terraform files

```bash
terraform fmt -recursive
```

---

## 4. Validate the configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

## 5. Review the deployment plan

```bash
terraform plan
```

Review the resources that Terraform is going to create.

---

## 6. Deploy

```bash
terraform apply
```

Enter:

```text
yes
```

Terraform will create the AWS infrastructure.

---

# 🔍 Expected AWS Resources

After deployment, the architecture should contain:

```text
AWS Account
│
├── SNS
│   └── beanflow-order-events
│
├── SQS
│   ├── beanflow-discord-queue
│   └── beanflow-slack-queue
│
├── Lambda
│   └── beanflow-notification-processor
│
├── IAM
│   └── Lambda execution role
│
└── CloudWatch
    └── Lambda logs
```

---

# 🧪 Testing the Architecture

## 1. Get the SNS Topic ARN

```bash
terraform output sns_topic_arn
```

Or:

```bash
terraform output -raw sns_topic_arn
```

---

## 2. Publish a Coffee Order

Run:

```bash
aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{
    "event_type": "ORDER_CREATED",
    "order_id": "ORD-10025",
    "store": "SG-ORCHARD",
    "items": [
      "Iced Latte",
      "Blueberry Muffin"
    ],
    "total": 12.50
  }'
```

---

# 🔀 Verify SNS Fan-Out

After publishing the event, check the two SQS queues.

### Discord Queue

```bash
aws sqs get-queue-attributes \
  --queue-url "$(terraform output -raw discord_queue_url)" \
  --attribute-names ApproximateNumberOfMessages
```

### Slack Queue

```bash
aws sqs get-queue-attributes \
  --queue-url "$(terraform output -raw slack_queue_url)" \
  --attribute-names ApproximateNumberOfMessages
```

The same event should be delivered to both queues.

Conceptually:

```text
                ORDER_CREATED
                     │
                     ▼
                    SNS
                     │
              ┌──────┴──────┐
              ▼             ▼
        Discord SQS      Slack SQS
              │             │
              └──────┬──────┘
                     ▼
                  Lambda
```

---

# ⚡ SQS → Lambda

Lambda consumes messages from the SQS queues through an AWS Lambda Event Source Mapping.

```text
SQS
 │
 │ ReceiveMessage
 ▼
Lambda
 │
 ├── Process event
 │
 └── DeleteMessage
```

The Lambda execution role requires:

```text
sqs:ReceiveMessage
sqs:DeleteMessage
sqs:GetQueueAttributes
```

These permissions are defined through Terraform.

---

# 📜 CloudWatch Logs

View Lambda logs using:

```bash
aws logs tail \
  /aws/lambda/beanflow-notification-processor \
  --follow
```

You should see the received coffee order event.

Example:

```text
Received event

ORDER_CREATED
ORD-10025
SG-ORCHARD
Total: 12.50
```

---

# 🔔 Discord and Slack Integration

The final version of the demo sends notifications to external business channels.

### Discord

```text
☕ BeanFlow Coffee

NEW ORDER

Order: ORD-10025
Store: SG-Orchard

1 × Iced Latte
1 × Blueberry Muffin

Total: $12.50
```

### Slack

```text
☕ BeanFlow Order Event

Order: ORD-10025
Store: SG-Orchard
Total: $12.50

Order received successfully.
```

Webhook URLs should **never be committed to Git**.

Use Terraform variables, environment variables, or preferably **AWS Secrets Manager** for production deployments.

---

# 🔐 IAM Design

The Lambda execution role follows the principle of least privilege.

```text
Lambda Execution Role
│
├── CloudWatch
│   └── Write Logs
│
└── SQS
    ├── ReceiveMessage
    ├── DeleteMessage
    └── GetQueueAttributes
```

The SNS topic is also explicitly authorized to send messages to the SQS queues.

---

# 🧯 Failure Scenario Demo

One of the main purposes of this demo is to demonstrate what happens when a downstream service fails.

## Scenario

Discord is temporarily unavailable.

```text
Coffee Order
     │
     ▼
    SNS
     │
     ▼
Discord SQS
     │
     │
     X Discord unavailable
```

The message remains available for processing according to the SQS visibility/retry configuration.

Meanwhile, the other consumer can continue independently.

This demonstrates why asynchronous messaging is useful for distributed systems.

---

# 🧠 Key Concepts Demonstrated

This project demonstrates the following cloud architecture concepts:

### Infrastructure as Code

Infrastructure is defined in Terraform rather than manually created in the AWS Console.

```text
Terraform
    │
    ▼
AWS Infrastructure
```

---

### Event-Driven Architecture

Business events are published instead of directly calling downstream services.

```text
ORDER_CREATED
     │
     ▼
    SNS
```

---

### Pub/Sub

SNS provides publish/subscribe fan-out.

```text
Publisher
    │
    ▼
   SNS
  /   \
 SQS   SQS
```

---

### Queue-Based Load Leveling

SQS buffers messages between producers and consumers.

```text
Producer
   │
   ▼
 SQS
   │
   ▼
Consumer
```

---

### Loose Coupling

The producer does not need to know who consumes the event.

---

### Serverless Processing

Lambda processes events without requiring a continuously running server.

---

### IAM Least Privilege

AWS permissions are explicitly granted only to the services that require them.

---

# 📈 Production Improvements

This project is intentionally simplified for learning and demonstration.

A production implementation could introduce the following improvements.

## Separate Lambda Consumers

Instead of:

```text
Discord SQS ──┐
              ├── Lambda ──► Discord / Slack
Slack SQS ────┘
```

Use:

```text
Discord SQS ──► Discord Lambda ──► Discord

Slack SQS ────► Slack Lambda ────► Slack
```

This prevents a failure in one notification channel from affecting another.

---

## Dead Letter Queues

Add DLQs:

```text
SQS
 │
 ├── Successful processing
 │
 └── Repeated failures
          │
          ▼
         DLQ
```

This allows failed messages to be investigated instead of being retried indefinitely.

---

## AWS Secrets Manager

Store:

```text
Discord Webhook URL
Slack Webhook URL
```

in AWS Secrets Manager instead of Terraform variables.

---

## CloudWatch Monitoring

Add metrics and alarms for:

* Queue depth
* Lambda errors
* Lambda duration
* Lambda throttling
* Dead-letter messages

---

## Message Schema

Introduce a standardized event schema:

```json
{
  "event_id": "evt-12345",
  "event_type": "ORDER_CREATED",
  "version": "1.0",
  "timestamp": "2026-08-10T18:00:00+08:00",
  "source": "beanflow-order-service",
  "data": {}
}
```

This makes the event contract easier to evolve.

---

# 🧹 Destroy the Environment

When the demo is finished:

```bash
terraform destroy
```

Review the resources that will be removed and enter:

```text
yes
```

This removes the infrastructure created by Terraform.

---

# 🎬 Demo Flow

A recommended live demonstration:

```text
1. Explain the BeanFlow business problem
            ↓
2. Show the architecture
            ↓
3. Show Terraform code
            ↓
4. terraform plan
            ↓
5. terraform apply
            ↓
6. Publish ORDER_CREATED event
            ↓
7. Show SNS fan-out
            ↓
8. Show messages arriving in SQS
            ↓
9. Show Lambda processing
            ↓
10. Show Discord + Slack notification
            ↓
11. Demonstrate downstream failure
            ↓
12. Explain SQS buffering and retry
            ↓
13. Discuss production improvements
            ↓
14. terraform destroy
```

---

# 🎓 Learning Objectives

By completing this project, you should understand how to:

* Build AWS infrastructure using Terraform
* Create SNS topics
* Create and configure SQS queues
* Configure SNS → SQS subscriptions
* Configure SQS → Lambda event sources
* Create Lambda IAM execution roles
* Apply least-privilege IAM policies
* Build asynchronous event-driven systems
* Implement fan-out messaging
* Handle downstream service failures
* Integrate AWS services with external webhooks
* Use Terraform to reproduce infrastructure consistently

---

# 📚 Architecture Reference

This project is based on the **Microservices Coffee Shop / Application Integration** architecture used in the accompanying presentation.

The core pattern is:

```text
Application Event
       │
       ▼
      SNS
   Fan-Out
    /    \
   ▼      ▼
 SQS     SQS
   \      /
    ▼    ▼
    Lambda
      │
   External
 Integrations
```

---

# 📌 Status

🚧 **Demo / Learning Project**

Current implementation:

* [x] Terraform AWS provider
* [x] SNS topic
* [x] Discord SQS queue
* [x] Slack SQS queue
* [x] SNS → SQS subscriptions
* [x] SQS queue policies
* [x] Lambda function
* [x] Lambda IAM role
* [x] Lambda SQS permissions
* [x] SQS → Lambda event source mappings
* [x] Discord webhook integration
* [ ] Slack webhook integration
* [ ] Dead Letter Queues
* [ ] AWS Secrets Manager
* [ ] CloudWatch alarms
* [ ] Production-grade event schema

---

## 👨‍💻 Author

**BeanFlow Coffee — AWS / Terraform Event-Driven Architecture Demo**

Built as a practical demonstration of AWS serverless architecture, Terraform Infrastructure as Code, and microservice integration patterns.
