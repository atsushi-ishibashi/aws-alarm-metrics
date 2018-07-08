# sns

## Topic Metrics

### `topic.sh`
Set `NumberOfNotificationsFailed` for `AWS/SNS`
```
sh topic.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <TopicName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `TopicName` value of dimensions. Used for Alarm Name.
