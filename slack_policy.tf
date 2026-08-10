data "aws_iam_policy_document" "slack_queue_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.slack.arn
    ]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        aws_sns_topic.order_events.arn
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "slack" {
  queue_url = aws_sqs_queue.slack.url
  policy    = data.aws_iam_policy_document.slack_queue_policy.json
}