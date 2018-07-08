# dynamodb

## Table Metrics

### `table.sh`
Set `ReadThrottleEvents`,`WriteThrottleEvents` for `AWS/DynamoDB`.
```
sh table.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <TableName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `TableName` value of dimensions. Used for Alarm Name.

## Table Operation Metrics

### `operation.sh`
Set `SuccessfulRequestLatency(except Scan)`,`ThrottledRequests`,`SystemErrors` for `AWS/DynamoDB`.
```
sh operation.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic <TableName>
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
-   `$3`: `TableName` value of dimensions. Used for Alarm Name.
-   `-g`: (Option) Threshold for `GetItem`
-   `-b`: (Option) Threshold for `BatchGetItem`
-   `-p`: (Option) Threshold for `PutItem`
-   `-w`: (Option) Threshold for `BatchWriteItem`
-   `-u`: (Option) Threshold for `UpdateItem`
-   `-q`: (Option) Threshold for `Query`
-   `-d`: (Option) Threshold for `DeleteItem`

## Account Metrics

### `account.sh`
Set `UserErrors` for `AWS/DynamoDB`.
```
sh account.sh <profile> arn:aws:sns:ap-northeast-1:123456789:alarm-sns-basic
```
-   `$1`: Use a specific profile from your credential file.
-   `$2`: Action ARN
