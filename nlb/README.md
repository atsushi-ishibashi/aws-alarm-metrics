# nlb

## Per AppELB Metrics

### `nlb.sh`
Set `ClientTLSNegotiationErrorCount` for `AWS/NetworkELB`
```
sh nlb.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic app/hoge/123456789
```
-   `-r`: (Option) Threshold for `TargetResponseTime`
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `LoadBalancer` value of dimensions. Used for Alarm Name.


## Per AppELB, per TG Metrics

### `targetgroup.sh`
Set `UnHealthyHostCount`,`TargetTLSNegotiationErrorCount` for `AWS/NetworkELB`
```
sh targetgroup.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic targetgroup/hoge/123456789 app/hoge/123456789
```
-   `-r`: (Option) Threshold for `TargetResponseTime`
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `TargetGroup` value of dimensions. Used for Alarm Name.
-   `$4`: `LoadBalancer` value of dimensions.
