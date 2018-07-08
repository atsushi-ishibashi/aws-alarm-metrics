# sqs

## Queue Metrics

### `sqs.sh`
Set `ApproximateAgeOfOldestMessage`,`ApproximateNumberOfMessagesDelayed` for `AWS/SQS`.
```
sh sqs.sh -r 3.0 <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <QueueName>
```
-   `-r`: (Option) Threshold for `ApproximateAgeOfOldestMessage`
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `QueueName` value of dimensions. Used for Alarm Name.
