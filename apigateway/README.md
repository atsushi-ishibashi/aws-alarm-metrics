# apigateway

## By Api Name

### `api.sh`
Set `Latency`,`IntegrationLatency`,`5XXError` for `AWS/ApiGateway`
```
sh api.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <ApiName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `ApiName` value of dimensions. Used for Alarm Name.
-   `-l`: (Option) Threshold for `Latency`
-   `-i`: (Option) Threshold for `IntegrationLatency`

## By Stage

### `stage.sh`
Set `Latency`,`IntegrationLatency`,`5XXError` for `AWS/ApiGateway`
```
sh stage.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <ApiName> <Stage>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `ApiName` value of dimensions. Used for Alarm Name.
-   `$4`: `Stage` value of dimensions. Used for Alarm Name.
-   `-l`: (Option) Threshold for `Latency`
-   `-i`: (Option) Threshold for `IntegrationLatency`
