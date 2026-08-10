resource "aws_lambda_function" "notification_processor" {
  function_name = "beanflow-notification-processor"

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  role = aws_iam_role.lambda.arn

  handler = "index.handler"
  runtime = "nodejs24.x"

  timeout     = 30
  memory_size = 128

  tags = {
    Project = "BeanFlow"
  }
}

resource "aws_lambda_event_source_mapping" "discord" {
  event_source_arn = aws_sqs_queue.discord.arn
  function_name    = aws_lambda_function.notification_processor.arn

  batch_size = 1

  enabled = true
}

resource "aws_lambda_event_source_mapping" "slack" {
  event_source_arn = aws_sqs_queue.slack.arn
  function_name    = aws_lambda_function.notification_processor.arn

  batch_size = 1

  enabled = true
}