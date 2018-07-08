# natgateway

## NAT Gateway Metrics

### `natgateway.sh`
Set `ErrorPortAllocation`,`PacketsDropCount` for `AWS/NATGateway`.
```
sh natgateway.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <NatGatewayId>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `NatGatewayId` value of dimensions. Used for Alarm Name.
