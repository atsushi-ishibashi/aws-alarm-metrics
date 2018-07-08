# logs

## Subscriptions Metrics

### `subscription.sh`
Set `DeliveryErrors`,`DeliveryThrottling` for `AWS/Logs`.
```
sh subscription.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <DestinationType> <FilterName> <LogGroupName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `DestinationType` value of dimensions. Used for Alarm Name.
-   `$4`: `FilterName` value of dimensions. Used for Alarm Name.
-   `$5`: `LogGroupName` value of dimensions. Used for Alarm Name.
