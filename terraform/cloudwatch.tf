resource "aws_cloudwatch_log_group" "boardgame_logs" {
  name              = "/aws/boardgame-webapp"
  retention_in_days = 14
}