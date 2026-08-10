# SNS is the event broadcaster - supporting fan-out to multiple subscribers

resource "aws_sns_topic" "order_events" {
  name = "beanflow-order-events"

  tags = {
    Project = "BeanFlow"
    Purpose = "Coffee Order Events"
  }
}
