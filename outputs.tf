# This file is used to define the outputs of the Terraform configuration, which can be used to reference the created resources in other configurations or for informational purposes.

output "sns_topic_arn" {
  description = "ARN of the BeanFlow Coffee order events SNS topic"
  value       = aws_sns_topic.order_events.arn
}

output "discord_queue_url" {
  description = "URL of the Discord SQS queue"
  value       = aws_sqs_queue.discord.url
}

output "slack_queue_url" {
  description = "URL of the Slack SQS queue"
  value       = aws_sqs_queue.slack.url
}

output "lambda_name" {
  description = "Name of the BeanFlow notification Lambda"
  value       = aws_lambda_function.notification_processor.function_name
}

output "lambda_arn" {
  description = "ARN of the BeanFlow notification Lambda"
  value       = aws_lambda_function.notification_processor.arn
}