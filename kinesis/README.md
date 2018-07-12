# kinesis

## Stream Metrics

### `stream.sh`
Set `GetRecords.Latency`,`PutRecord.Latency`,`PutRecords.Latency`,
`ReadProvisionedThroughputExceeded`,`WriteProvisionedThroughputExceeded` for `AWS/Kinesis`.
```
sh stream.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <StreamName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `StreamName` value of dimensions. Used for Alarm Name.
-   `-g`: (Option) Threshold for `GetRecords.Latency`
-   `-p`: (Option) Threshold for `PutRecord.Latency`
-   `-q`: (Option) Threshold for `PutRecords.Latency`
