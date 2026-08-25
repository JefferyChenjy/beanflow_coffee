# key architectural improvement. If Discord stops responding, don't want to lose the event. 
# fan-out to SQS queues for different platforms. Lambda will process the events from the queues and send to Discord and Slack.

resource "aws_sqs_queue" "discord" {
  name = "beanflow-discord-queue"

  visibility_timeout_seconds = 60

  tags = {
    Project  = "BeanFlow"
    Consumer = "Discord"
  }
}

resource "aws_sqs_queue" "slack" {
  name = "beanflow-slack-queue"

  visibility_timeout_seconds = 60

  tags = {
    Project  = "BeanFlow"
    Consumer = "Slack"
  }
}

resource "aws_sns_topic_subscription" "discord" {
  topic_arn = aws_sns_topic.order_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.discord.arn

  raw_message_delivery = true
}

resource "aws_sns_topic_subscription" "slack" {
  topic_arn = aws_sns_topic.order_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.slack.arn

  raw_message_delivery = true
}