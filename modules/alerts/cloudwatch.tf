resource "aws_cloudwatch_event_rule" "build" {
  name        = "build-complete"
  description = "Alert on status of Packer pipeline"

  event_pattern = <<EOF
{
  "detail-type": [
    "AmiBuilder"
  ],
  "source": [
    "com.ami.builder"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.build.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.build_updates.arn
}